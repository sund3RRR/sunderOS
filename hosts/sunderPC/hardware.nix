{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/38a57dfa-902d-4b97-bfca-7a72d462a2a4";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/EF50-2A72";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  swapDevices = lib.mkForce [ ];

  # Kernel
  boot = {
    kernelPackages = pkgs.linuxPackages;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = with config.boot.kernelPackages; [ ];
    initrd = {
      verbose = false;
      availableKernelModules = [
        "nvme"                # NVMe SSD support
        "xhci_pci"            # USB 3.0 controller support
        "ahci"                # SATA controller support
        "usbhid"              # USB HID device support
        "usb_storage"         # USB mass storage support
        "sd_mod"              # SD card reader support
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
      "amdgpu.ppfeaturemask=0xffffffff" # Enable all AMDGPU power management features
      "radeon.cik_support=0"            # Disable CIK support in Radeon driver
      "amdgpu.cik_support=1"            # Enable CIK support in AMDGPU driver
    ];
    consoleLogLevel = 0;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-utils
        vaapiVdpau
      ];
    };
  };

  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
