{
  config,
  pkgs,
  lib,
  ...
}:
{
  hardware.tuxedo-control-center.enable = true;

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
}
