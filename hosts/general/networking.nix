{
  lib,
  hostname,
  ...
}:
{
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  services.avahi.enable = true;
}
