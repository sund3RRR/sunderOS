{
  ...
}:
{
  users.users.sunder.extraGroups = [
    "docker"
    "libvirtd"
  ];
  users.groups.libvirtd.members = [ "sunder" ];

  virtualisation.docker.enable = true;
  #virtualisation.docker.rootless.enable = true;

  programs.virt-manager.enable = true;  
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
