{
  pkgs,
  ...
}:
{
  services.xserver.displayManager.gdm.enable = true;

  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      # Set GDM display scaling factor to 2x (for HiDPI displays)
      [org.gnome.desktop.interface]
      scaling-factor=2

      # Increase timeout for compositor's alive check (30 seconds)
      [org.gnome.mutter]
      check-alive-timeout=30000 # 30 seconds
    '';
  };

  environment.systemPackages =
    with pkgs;
    [
      # GNOME apps
      amberol        # Music player
      collision      # Hash checker
      devtoolbox     # Developer tool box (prettier, eslint, etc)
      errands        # Task manager
      fragments      # Torrent client
      gnome-tweaks   # GNOME tweaks

      # Astra Monitor extension
      nethogs
      wirelesstools
      iotop
      libgtop
      pciutils
    ]
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      arcmenu
      astra-monitor
      blur-my-shell
      caffeine
      clipboard-history
      # control-monitor-brightness-and-volume-with-ddcutil // TEMPORARY MUST BE INSTALLED MANUALLY
      dash-to-dock
      dash-to-panel
      gtk4-desktop-icons-ng-ding
      gnome-40-ui-improvements
      just-perfection
      vitals
      quick-settings-tweaker
    ]);

  environment.variables = {
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0"; # For astra-monitor
  };
}
