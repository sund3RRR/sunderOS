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

  # Kernel
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    initrd = {
      verbose = false;
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
    };
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
  };

  # Plymouth
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };
}
