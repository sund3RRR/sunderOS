{
  config,
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
    kernelPackages = pkgs.linuxMechrevo;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = with config.boot.kernelPackages; [ yt6801 tuxedo-drivers ];
    initrd = {
      verbose = false;
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "yt6801"
      ];
      kernelModules = [ ];
    };
    kernelParams = [
      "quiet" # Suppress boot messages
      "splash" # Enable graphical boot splash
      "boot.shell_on_fail" # Show shell on boot failure
      "loglevel=3" # Set kernel log level to errors only
      "rd.systemd.show_status=false" # Disable systemd status messages
      "rd.udev.log_level=3" # Set udev log level to errors only
      "udev.log_priority=3" # Set udev log priority to errors only
      "amdgpu.dcdebugmask=0x10" # Disable PSR (Panel Self Refresh) in AMDGPU driver
      "amdgpu.ppfeaturemask=0xffffffff" # Enable all AMDGPU power management features
      "acpi.ec_no_wakeup=1" # Disable EC wakeup events
      "radeon.cik_support=0" # Disable CIK support in Radeon driver
      "amdgpu.cik_support=1" # Enable CIK support in AMDGPU driver
    ];
    consoleLogLevel = 0;
  };

  # Plymouth
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };
}
