{
  lib,
  ...
}:
{
  networking.hostName = "sunderBook";
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkDefault true;

  networking.firewall.enable = true;
}
