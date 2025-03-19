{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Kernel
  boot = {
    kernelPackages = pkgs.linuxMechrevo;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = with config.boot.kernelPackages; [
      yt6801
      tuxedo-drivers
    ];
    initrd = {
      verbose = false;
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "snd_hda_intel"
        "yt6801" # For Mechrevo 14X Ethernet port
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
      "amdgpu.dcdebugmask=0x10"         # Disable PSR (Panel Self Refresh) in AMDGPU driver
      "amdgpu.ppfeaturemask=0xffffffff" # Enable all AMDGPU power management features
      "acpi.ec_no_wakeup=1"             # Disable EC wakeup events
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

  hardware.tuxedo-control-center.enable = true;
  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
