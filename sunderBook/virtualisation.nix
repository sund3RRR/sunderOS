{
  ...
}:
{
  programs.virt-manager.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless.enable = true;

  users.groups.libvirtd.members = [ "sunder" ];
}
