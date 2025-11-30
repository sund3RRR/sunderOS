#!/usr/bin/env nix-shell
#! nix-shell -i python3 -p "python3.withPackages (ps: with ps; [ ps.requests ])"

import zipfile
import requests
import io
import re
from pathlib import Path
import tempfile

ZIP_URL = "https://github.com/Snowy-Fluffy/zapret.cfgs/archive/refs/heads/main.zip"

def parse_env(text: str) -> dict:
    # 1) regex for env pattern
    var_pattern = re.compile(r'(?=^[A-Z0-9_]+=)', re.MULTILINE)

    # 2) split before regex
    blocks = var_pattern.split(text)

    # 3) remove empty strings and comments
    blocks = [b.strip() for b in blocks if b.strip()]
    blocks = [b for b in blocks if not b.lstrip().startswith("#")]

    result = {}
    for block in blocks:
        # 4) split before first '='
        key, _, value = block.partition("=")
        key = key.strip()
        raw_value = value.strip()

        # 5) split value for clean up
        lines = raw_value.split("\n")

        # 6) clean up: remove empty lines, comments, quote lines
        result_lines = []
        for line in lines:
            line = line.strip()
            if line.startswith("#") or line == '' or line == '"':
                continue
            result_lines.append(line)

        # 7) join
        result[key] = "\n".join(result_lines)

    return result

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


def load_list(path: Path) -> str:
    lines = path.read_text().splitlines()
    items = [f'"{x}"' for x in lines]
    return f'[{"\n".join(items)}]'

def load_hostlist(base: Path) -> str:
    path = base / "lists" / "list-basic.txt"
    return load_list(path)

def load_discord_list(base: Path) -> str:
    file = base / "lists" / "ipset-discord.txt"
    return load_list(file)

def replace_paths(p: str) -> str:
    p = p.replace('/opt/zapret/ipset/zapret-hosts-user.txt', '${hostlist}')
    p = p.replace('/opt/zapret/ipset/ipset-discord.txt', '${discordHostlist}')
    p = p.replace('/opt/zapret/files/fake/autohostlist.txt', '/var/run/autohostlist.txt')
    p = re.sub(r'/opt/zapret/files', '${zapretData}', p)
    return p


def load_strategies(base: Path) -> dict:
    cfg_dir = base / "configurations"
    strategies = {}

    for cfg_file in sorted(cfg_dir.glob("*")):
        if not cfg_file.is_file():
            continue
        
        # Clean strategy name
        strategy_name = cfg_file.stem
        strategy_name = strategy_name.replace("для_МГТС", "MGTS").replace("МГТС", "MGTS")

        text = cfg_file.read_text()

        envs = parse_env(text)

        nfqws_opt = envs["NFQWS_OPT"]
        nfqws_opt = replace_paths(nfqws_opt)

        nfqws_udp_ports = envs["NFQWS_PORTS_UDP"]
        nfqws_udp_ports_list = [f'"{p.replace("-", ":")}"' for p in nfqws_udp_ports.split(",")]

        formatted_ports = ' '.join(nfqws_udp_ports_list)
        formatted_strategy = "\n".join(f'"{nix_escape(f)}"' for f in nfqws_opt.split("\n"))

        nix_value = f'{{ udpPorts = [{formatted_ports}]; filters = [{formatted_strategy}]; }}'

        strategies[strategy_name] = nix_value

    return strategies


def generate_nix(hostlist_nix: str, discord_list_nix: str, strategies: dict) -> str:
    strategy_attrs = "\n".join(f"{name} = {lst};" for name, lst in strategies.items())
    enum_list = "\n".join([f'"{name}"' for name in strategies.keys()])

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
