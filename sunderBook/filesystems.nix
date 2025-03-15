{
  lib,
  ...
}:
{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a4dfc57c-880c-44e6-8655-31ef5dafc536";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3752-DDAF";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = lib.mkForce [ ];
}
