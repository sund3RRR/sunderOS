{
  pkgs,
  lib,
  config,
  ...
}:
let
  hostlist = [
    "10tv.app"
    "7tv.app"
    "7tv.io"
    "cloudflare-ech.com"
    "dis.gd"
    "discord-attachments-uploads-prd.storage.googleapis.com"
    "discord.app"
    "discord.co"
    "discord.com"
    "discord.design"
    "discord.dev"
    "discord.gift"
    "discord.gifts"
    "discord.gg"
    "discord.media"
    "discord.new"
    "discord.store"
    "discord.status"
    "discord-activities.com"
    "discordactivities.com"
    "discordapp.com"
    "discordapp.net"
    "discordcdn.com"
    "discordmerch.com"
    "discordpartygames.com"
    "discordsays.com"
    "discordsez.com"
    "ggpht.com"
    "googlevideo.com"
    "jnn-pa.googleapis.com"
    "stable.dl2.discordapp.net"
    "wide-youtube.l.google.com"
    "youtube-nocookie.com"
    "youtube-ui.l.google.com"
    "youtube.com"
    "youtubeembeddedplayer.googleapis.com"
    "youtubekids.com"
    "youtubei.googleapis.com"
    "youtu.be"
    "yt-video-upload.l.google.com"
    "ytimg.com"
    "ytimg.l.google.com"
    "github.com"
    "facebook.com"
    "instagram.com"
    "rutracker.org"
  ];
  whitelist = pkgs.writeText "zapret-whitelist" (lib.concatStringsSep "\n" hostlist);
in
{
  options.sunderOS.zapret = {
    enable = lib.mkEnableOption "enable zapret conf";
  };
  config = lib.mkIf config.sunderOS.zapret.enable {
    services.zapret = {
      enable = true;
      udpSupport = true;
      udpPorts = [
        "443"
        "50000:50100"
      ];
      params = [
        "--filter-udp=443"
        "--hostlist=\"${whitelist}\""
        "--dpi-desync=fake"
        "--dpi-desync-repeats=6"
        "--dpi-desync-fake-quic=\"${whitelist}\""
        "--new"
        "--filter-udp=50000-50100"
        "--ipset=\"${pkgs.zapret-data}/share/zapret-data/ipset-discord.txt\""
        "--dpi-desync=fake"
        "--dpi-desync-any-protocol"
        "--dpi-desync-cutoff=d3"
        "--dpi-desync-repeats=6"
        "--new"
        "--filter-tcp=80" "--hostlist=\"${whitelist}\""
        "--dpi-desync=fake,split2"
        "--dpi-desync-autottl=2"
        "--dpi-desync-fooling=md5sig"
        "--new"
        "--filter-tcp=443"
        "--hostlist=\"${whitelist}\""
        "--dpi-desync=fake,split"
        "--dpi-desync-autottl=2"
        "--dpi-desync-repeats=6"
        "--dpi-desync-fooling=badseq"
        "--dpi-desync-fake-tls=\"${whitelist}\""
      ];
    };
  };
}