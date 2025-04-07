{
  pkgs,
  hostname,
  ...
}:
{
  programs.amnezia-vpn.enable = true;

  # Enable AppImage support.
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.dconf.enable = true;

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/sunderOS#${hostname}";
    };
  };
}