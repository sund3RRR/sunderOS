{
  lib,
  ...
}:
{
  networking.hostName = "sunderPC";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 3389 ];
  networking.firewall.allowedUDPPorts = [ 3389 ];
}
