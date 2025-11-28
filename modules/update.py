#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (ps: with ps; [ ps.requests ])"

import zipfile
import requests
import io
import re
from pathlib import Path
import tempfile

ZIP_URL = "https://github.com/Snowy-Fluffy/zapret.cfgs/archive/refs/heads/main.zip"


def nix_escape(s: str) -> str:
    """Escape for Nix string literals."""
    return s.replace('\\', '\\\\').replace('"', '\\"')


def download_and_extract() -> Path:
    print("Downloading repository...")
    r = requests.get(ZIP_URL)
    r.raise_for_status()
    z = zipfile.ZipFile(io.BytesIO(r.content))

    tmp_dir = tempfile.TemporaryDirectory()
    z.extractall(tmp_dir.name)

    # Возвращаем путь к корневой папке внутри tmp_dir
    root_dir_name = z.namelist()[0].split("/")[0]
    return Path(tmp_dir.name) / root_dir_name, tmp_dir


def load_hostlist(base: Path) -> str:
    file = base / "lists" / "list-basic.txt"
    lines = [l.strip() for l in file.read_text().splitlines() if l.strip()]
    items = ["\"" + nix_escape(x) + "\"" for x in lines]
    return "[\n    " + "\n    ".join(items) + "\n  ]"


def load_discord_list(base: Path) -> str:
    file = base / "lists" / "ipset-discord.txt"
    lines = [l.strip() for l in file.read_text().splitlines() if l.strip()]
    items = ["\"" + nix_escape(x) + "\"" for x in lines]
    return "[\n    " + "\n    ".join(items) + "\n  ]"


def load_strategies(base: Path) -> dict:
    cfg_dir = base / "configurations"
    strategies = {}

    for cfg_file in sorted(cfg_dir.glob("*")):
        if not cfg_file.is_file():
            continue

        name = cfg_file.stem
        text = cfg_file.read_text()

        # Извлекаем NFQWS_OPT до комментария # none,...
        m = re.search(r'NFQWS_OPT="([\s\S]*?)"\s*#\s*none,ipset,hostlist,autohostlist', text)
        if not m:
            continue
        block = m.group(1)

        # Удаляем все строки, начинающиеся с #
        clean = "\n".join(line for line in block.splitlines() if not line.lstrip().startswith("#")).strip()

        # Split, сохранив --new
        parts = re.split(r'(?<=--new)\s*\^?\s*', clean)
        parts = [p.strip() for p in parts if p.strip()]

        # Заменяем пути и убираем лишнее
        cleaned = []
        for p in parts:
            p = p.replace('/opt/zapret/ipset/zapret-hosts-user.txt', '${hostlist}')
            p = p.replace('/opt/zapret/ipset/ipset-discord.txt', '${discordHostlist}')
            p = p.replace('/opt/zapret/files/fake/autohostlist.txt', '/var/run/autohostlist.txt')
            p = re.sub(r'/opt/zapret/files', '${zapretData}', p)
            p = p.replace('"', '').replace('\\', '').strip()
            cleaned.append(p)

        # Берём порты UDP прямо из переменной
        m_ports = re.search(r'^NFQWS_PORTS_UDP=([^\n]+)', text, re.MULTILINE)
        udp_ports = [p.strip() for p in m_ports.group(1).split(",")] if m_ports else []

        for i in range(0, len(udp_ports)):
          udp_ports[i] = udp_ports[i].replace("-", ":")

        nix_value = "{\n" \
                    f"      udpPorts = [ {' '.join('\"'+x+'\"' for x in udp_ports)} ];\n" \
                    f"      filters = [\n" + \
                    "\n".join(f"        \"{nix_escape(f)}\"" for f in cleaned) + \
                    "\n      ];\n    }"

        # Чистим имя
        name = name.replace("для_МГТС", "MGTS").replace("МГТС", "MGTS")
        strategies[name] = nix_value

    return strategies


def generate_nix(hostlist_nix: str, discord_list_nix: str, strategies: dict) -> str:
    strategy_attrs = "\n".join(f"    {name} = {lst};" for name, lst in strategies.items())
    enum_list = "\n        ".join([f'"{name}"' for name in strategies.keys()])

    return f"""{{ pkgs, lib, config, ... }}:

let
  zapretDataDrv =
    {{ stdenvNoCC, fetchFromGitHub }}:
    stdenvNoCC.mkDerivation (finalAttrs: {{
      pname = "zapret-data";
      version = "72.3";

      src = fetchFromGitHub {{
        owner = "bol-van";
        repo = "zapret";
        tag = "v${{finalAttrs.version}}";
        hash = "sha256-Q36us5qdDsdZ2HBTRXt/9aKiG8OZJdZqr/90ymePLLg=";
      }};

      dontBuild = true;

      installPhase = ''
        runHook preInstall
        cp -r files $out/
        runHook postInstall
      '';
    }});

  zapretData = zapretDataDrv {{
    stdenvNoCC = pkgs.stdenvNoCC;
    fetchFromGitHub = pkgs.fetchFromGitHub;
  }};

  hosts = {hostlist_nix};
  discordIPs = {discord_list_nix};

  hostlist = pkgs.writeText "zapret-hostlist" (lib.concatStringsSep "\\n" hosts);
  discordHostlist = pkgs.writeText "zapret-discord-hostlist" (lib.concatStringsSep "\\n" discordIPs);

  strategies = {{
{strategy_attrs}
  }};

  cfg = config.sunderOS.zapret;
in
{{
  options.sunderOS.zapret = {{
    enable = lib.mkEnableOption "Enable zapret";

    strategy = lib.mkOption {{
      type = lib.types.enum [
        {enum_list}
      ];
      default = "{list(strategies.keys())[0]}";
      description = "Zapret strategy to use";
    }};
  }};

  config = lib.mkIf cfg.enable {{
    services.zapret = {{
      enable = true;
      udpSupport = true;
      udpPorts = strategies.${{cfg.strategy}}.udpPorts;
      params = strategies.${{cfg.strategy}}.filters;
    }};
  }};
}}
"""


def main():
    base, tmp_dir = download_and_extract()

    hostlist_nix = load_hostlist(base)
    discord_list_nix = load_discord_list(base)
    strategies = load_strategies(base)

    nix_text = generate_nix(hostlist_nix, discord_list_nix, strategies)
    with open("zapret.nix", "w") as f:
        f.write(nix_text)

    # Temporary directory удалится автоматически после выхода из контекста
    tmp_dir.cleanup()


if __name__ == "__main__":
    main()
