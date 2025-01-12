{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.gaming;
in
{
  options.programs.gaming = {
    enable = lib.mkEnableOption "Gaming module";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
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

    environment.systemPackages = with pkgs; [
      mangohud
      mangojuice
      protonup-qt
    ];
  };

  meta.maintainers = with lib.maintainers; [ sund3RRR ];
}
