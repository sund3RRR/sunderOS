{
  ...
}:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b6b793bc-8358-45ba-84a2-7f35427725c6";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3B1B-7523";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ ];
}
