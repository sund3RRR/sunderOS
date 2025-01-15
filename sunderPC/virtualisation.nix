{
  ...
}:
{
  programs.virt-manager.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker.enable = true;

  users.groups.libvirtd.members = [ "sunder" ];
}
