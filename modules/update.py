import zipfile
import requests
import io
import re
from pathlib import Path

ZIP_URL = "https://github.com/Snowy-Fluffy/zapret.cfgs/archive/refs/heads/main.zip"


def download_and_extract():
    print("Downloading repository...")
    r = requests.get(ZIP_URL)
    r.raise_for_status()

    z = zipfile.ZipFile(io.BytesIO(r.content))
    root = z.namelist()[0]  # zapret.cfgs-main/

    extract_dir = Path("zapret_cfgs")
    if extract_dir.exists():
        pass
    else:
        extract_dir.mkdir()

    z.extractall(extract_dir)
    return extract_dir / root


def nix_escape(s: str) -> str:
    """Escape for Nix string literals."""
    return s.replace('\\', '\\\\').replace('"', '\\"')


def load_hostlist(base: Path):
    file = base / "lists" / "list-basic.txt"
    lines = [l.strip() for l in file.read_text().splitlines() if l.strip()]
    # Nix list of strings
    items = ["\"" + nix_escape(x) + "\"" for x in lines]
    return "[\n    " + "\n    ".join(items) + "\n  ]"

def load_discord_list(base: Path):
    file = base / "lists" / "ipset-discord.txt"
    lines = [l.strip() for l in file.read_text().splitlines() if l.strip()]
    # Nix list of strings
    items = ["\"" + nix_escape(x) + "\"" for x in lines]
    return "[\n    " + "\n    ".join(items) + "\n  ]"

def load_strategies(base: Path):
    cfg_dir = base / "configurations"

    strategies = {}
    for cfg_file in sorted(cfg_dir.glob("*")):
        if not cfg_file.is_file():
            continue

        name = cfg_file.stem
        text = cfg_file.read_text()

        # Extract NFQWS_OPT block safely (multiline, non-greedy)
        m = re.search(
            r'NFQWS_OPT="([\s\S]*?)"\s*#\s*none,ipset,hostlist,autohostlist',
            text,
            re.MULTILINE,
        )

        if not m:
            return

        block = m.group(1)

        # Удаляем все строки, начинающиеся с #
        clean = "\n".join(
            line for line in block.splitlines()
            if not line.lstrip().startswith("#")
        ).strip()

        # Разделяем, сохранив --new
        parts = re.split(r'(?<=--new)\s*\^?\s*', clean)
        parts = [p.strip() for p in parts if p.strip()]

        cleaned = []
        for p in parts:
            # Replace hostlist paths
            p = p.replace('/opt/zapret/ipset/zapret-hosts-user.txt', '${hostlist}')
            p = p.replace('/opt/zapret/ipset/ipset-discord.txt', '${discordHostlist}')
            p = p.replace('/opt/zapret/files/fake/autohostlist.txt', '/var/zapret/autohostlist.txt')

            # Replace paths
            p = re.sub(r'/opt/zapret', '${zapretData}', p)

            # strip quotes and backslashes
            p = p.replace('"', '').replace('\\', '').strip()

            cleaned.append(p)

        # Nix list
        nix_list = "[\n      " + "\n      ".join(
            ["\"" + nix_escape(x) + "\"" for x in cleaned]
        ) + "\n    ]"
        name = name.replace("для_МГТС", "MGTS")
        name = name.replace("МГТС", "MGTS")
        strategies[name] = nix_list

    return strategies



def generate_nix(hostlist_nix, discord_list_nix, strategies):
    strategy_attrs = ""
    for name, lst in strategies.items():
        strategy_attrs += f'\t\t{name} = {lst};\n'

    # enum for strategies
    enum_list = "\n\t\t\t\t".join([f'"{name}"' for name in strategies.keys()])

    return f"""
{{ pkgs, lib, config, ... }}:

let
  zapretDataDrv = {{ stdenvNoCC, fetchFromGitHub }}:
    stdenvNoCC.mkDerivation {{
      pname = "zapret-data";
      version = "72.3";

      src = fetchFromGitHub {{
        owner = "bol-van";
        repo = "zapret";
        tag = version;
        hash = "";
      }};

      installPhase = ''
        runHook preInstall
        cp -r files $out/
        runHook postInstall
      '';
    }};
  zapretData = zapretDataDrv {{ stdenvNoCC = pkgs.stdenvNoCC; fetchFromGitHub = pkgs.fetchFromGitHub }};

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
    enable = lib.mkEnableOption "enable zapret conf";

    strategy = lib.mkOption {{
      type = lib.types.enum [
        {enum_list}
      ];
      default = "{list(strategies.keys())[0]}";
      description = ''
        Zapret strategy.
      '';
    }};
  }};

  config = lib.mkIf cfg.enable {{
    services.zapret = {{
      enable = true;
      udpSupport = true;
      udpPorts = [
        "443"
        "50000:50100"
      ];
      params = strategies.${{cfg.strategy}};
    }};
  }};
}}
"""


def main():
    base = download_and_extract()

    hostlist_nix = load_hostlist(base)
    discord_list_nix = load_discord_list(base)
    strategies = load_strategies(base)

    nix_text = generate_nix(hostlist_nix, discord_list_nix, strategies)
    with open("result.nix", "w") as f:
        f.write(nix_text)


if __name__ == "__main__":
    main()
