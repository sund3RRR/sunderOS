{
  username,
  ...
}:
{
  users.users.${username}.extraGroups = [
    "docker"
    "libvirtd"
    "podman"
  ];
  users.groups.libvirtd.members = [ username ];

  virtualisation.docker.enable = true;

  virtualisation.podman.enable = true;

  programs.virt-manager.enable = true;  
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.allowedBridges = [
    "virbr0"
  ];
}
