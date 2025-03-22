{
  config,
  lib,
  modulesPath,
  ...
}:
{
  # imports = [ 
  #   (modulesPath + "/installer/scan/not-detected.nix")
  # ];
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
