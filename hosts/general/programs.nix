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

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    shellInit = ''
      rebuild() {
        sudo nixos-rebuild "$@" --flake ~/sunderOS#${hostname}
      }
    '';
  };
}