{
  pkgs,
  ...
}:
{
  # nixpkgs.overlays = [
  #   # GNOME 47: triple-buffering-v4-47
  #   (final: prev: {
  #     mutter = prev.mutter.overrideAttrs (oldAttrs: {
  #       # GNOME dynamic triple buffering (huge performance improvement)
  #       # See https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441
  #       # Also https://gitlab.gnome.org/vanvugt/mutter/-/tree/triple-buffering-v4-47
  #       src = final.fetchFromGitLab {
  #         domain = "gitlab.gnome.org";
  #         owner = "vanvugt";
  #         repo = "mutter";
  #         rev = "triple-buffering-v4-47";
  #         hash = "sha256-6n5HSbocU8QDwuhBvhRuvkUE4NflUiUKE0QQ5DJEzwI=";
  #       };

  #       # GNOME 47 requires the gvdb subproject which is not included in the triple-buffering branch
  #       # This copies the necessary gvdb files from the official GNOME repository
  #       preConfigure = let
  #         gvdb = final.fetchFromGitLab {
  #           domain = "gitlab.gnome.org";
  #           owner = "GNOME";
  #           repo = "gvdb";
  #           rev = "2b42fc75f09dbe1cd1057580b5782b08f2dcb400";
  #           hash = "sha256-CIdEwRbtxWCwgTb5HYHrixXi+G+qeE1APRaUeka3NWk=";
  #         };
  #       in ''
  #         cp -a "${gvdb}" ./subprojects/gvdb
  #       '';
  #     });
  #   })
  # ];

  services.xserver.displayManager.gdm.enable = true;

  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      [org.gnome.desktop.interface]
      scaling-factor=2
      [org.gnome.mutter]
      check-alive-timeout=30000
    '';
  };

  environment.systemPackages =
    with pkgs;
    [
      amberol
      collision
      devtoolbox
      errands
      fragments
      gnome-tweaks
    ]
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      arcmenu
      astra-monitor
      blur-my-shell
      dash-to-dock
      dash-to-panel
      gtk4-desktop-icons-ng-ding
    ]);
}
