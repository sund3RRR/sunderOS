{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/765e91df-c6b4-4622-86ca-7fb28e04f32e";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1431-961D";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  fileSystems."/home/sund3rrr/Desktop/Shared" = {
    device = "share";
    fsType = "virtiofs";
  };

  swapDevices = lib.mkForce [ ];

  # Kernel
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelModules = [ ];
    extraModulePackages = with config.boot.kernelPackages; [ ];
    initrd = {
      verbose = false;
      availableKernelModules = [
        "xhci_pci"            # USB 3.0 controller support
      ];
      kernelModules = [ ];
    };
    kernelParams = [
      "quiet"                           # Suppress boot messages
      "splash"                          # Enable graphical boot splash
      "boot.shell_on_fail"              # Show shell on boot failure
      "loglevel=3"                      # Set kernel log level to errors only
      "rd.systemd.show_status=false"    # Disable systemd status messages
      "rd.udev.log_level=3"             # Set udev log level to errors only
      "udev.log_priority=3"             # Set udev log priority to errors only
    ];
    consoleLogLevel = 0;
  };
}
