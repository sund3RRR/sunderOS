{
  pkgs,
  ...
}:
{
  # Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    splashImage = null;
    theme = pkgs.elegant-grub-theme.override {
      theme = "forest";
      type = "float";
      side = "left";
      color = "dark";
      resolution = "4k";
      logo = "Nixos";
    };
  };

  # Plymouth
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };
}
