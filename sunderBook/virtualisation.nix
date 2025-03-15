{
  ...
}:
{
  virtualisation.docker.enable = true;
  #virtualisation.docker.rootless.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "sunder" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
