{
  pkgs,
  ...
}:
{
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
    ]
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      arcmenu
      blur-my-shell
      dash-to-dock
      dash-to-panel
      gtk4-desktop-icons-ng-ding
    ]);
}
