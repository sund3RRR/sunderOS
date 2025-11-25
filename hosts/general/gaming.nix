{
  pkgs,
  ...
}:
{
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

  hardware.xone.enable = true;

  environment.systemPackages = with pkgs; [
    goverlay
    vkbasalt
    mangohud
    protonup-qt
  ];
}
