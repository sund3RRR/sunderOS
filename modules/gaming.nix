{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming;
in
{
  options.gaming = {
    enable = lib.mkEnableOption "Gaming module";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
   #     gamescopeSession.enable = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      gamemode = {
        enable = true;
        enableRenice = true;
      };
    };

    hardware.xone.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
      goverlay
      protonup-qt
    ];
  };

  meta.maintainers = with lib.maintainers; [ sund3RRR ];
}
