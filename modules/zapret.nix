{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    zapret.enable = lib.mkEnableOption "enable zapret conf";
    # zapret.strategy
  };
  config = lib.mkIf config.zapret.enable {
    services.zapret = {
      enable = true;
      udpSupport = true;
      udpPorts = [
        "443"
        "50000:50100"
      ];
      params = [
        "--filter-udp=443"
        "--hostlist=\"${pkgs.zapret-data}/share/zapret-data/list-general.txt\""
        "--dpi-desync=fake"
        "--dpi-desync-repeats=6"
        "--dpi-desync-fake-quic=\"${pkgs.zapret-data}/share/zapret-data/quic_initial_www_google_com.bin\""
        "--new"
        "--filter-udp=50000-50100"
        "--ipset=\"${pkgs.zapret-data}/share/zapret-data/ipset-discord.txt\""
        "--dpi-desync=fake"
        "--dpi-desync-any-protocol"
        "--dpi-desync-cutoff=d3"
        "--dpi-desync-repeats=6"
        "--new"
        "--filter-tcp=80" "--hostlist=\"${pkgs.zapret-data}/share/zapret-data/list-general.txt\""
        "--dpi-desync=fake,split2"
        "--dpi-desync-autottl=2"
        "--dpi-desync-fooling=md5sig"
        "--new"
        "--filter-tcp=443"
        "--hostlist=\"${pkgs.zapret-data}/share/zapret-data/list-general.txt\""
        "--dpi-desync=fake,split"
        "--dpi-desync-autottl=2"
        "--dpi-desync-repeats=6"
        "--dpi-desync-fooling=badseq"
        "--dpi-desync-fake-tls=\"${pkgs.zapret-data}/share/zapret-data/tls_clienthello_www_google_com.bin\""
      ];
    };
  };
}