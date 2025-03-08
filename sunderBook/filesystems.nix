{
  lib,
  ...
}:
{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/16818741-98a7-4ee1-b1b4-b97591d1ecb9";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3752-DDAF";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = lib.mkForce [ ];
}
