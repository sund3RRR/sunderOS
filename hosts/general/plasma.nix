{
  pkgs,
  ...
}:
{ 
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
}