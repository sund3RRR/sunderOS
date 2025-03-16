{
  pkgs,
  ...
}:
{
  programs.amnezia-vpn.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.dconf.enable = true;

  # Install firefox.
  programs.firefox.enable = true;
  programs.firefox.nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/sunderOS#sunderBook";
    };
  };
}