{
  config,
  lib,
  ...
}:
{
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
