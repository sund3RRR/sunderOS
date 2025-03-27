{
  pkgs,
  ...
}:
{ 
  #services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      # Set GDM display scaling factor to 2x (for HiDPI displays)
      [org.gnome.desktop.interface]
      scaling-factor=2

      # Increase timeout for compositor's alive check (30 seconds)
      [org.gnome.mutter]
      check-alive-timeout=30000

      # Disable 'sleep' and 'airplane' media buttons on keyboard
      [org.gnome.settings-daemon.plugins.media-keys]
      suspend-static="[\'\']"
      rfkill-static="[\'\']"
    '';
  };
  
  xdg.terminal-exec.enable = true;
  xdg.terminal-exec.settings = {
    GNOME = [
      "org.gnome.Ptyxis.desktop"
    ];
    default = [
      "org.gnome.Ptyxis.desktop"
    ];
  };

  programs.nautilus-open-any-terminal.enable = true;
  programs.nautilus-open-any-terminal.terminal = "ptyxis";

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-text-editor
    gnome-contacts
    gnome-maps
    gnome-console
    gnome-music
    gnome-system-monitor
    totem
    yelp
    geary
  ];

  environment.systemPackages =
    with pkgs;
    [
      # GNOME apps
      collision      # Hash checker
      clapper        # Video player
      dconf-editor   # GSettings editor
      devtoolbox     # Developer tool box (prettier, eslint, etc)
      dialect        # Translate app
      easyeffects    # Audio effects
      fragments      # Torrent client
      gapless        # Music player
      gnome-tweaks   # GNOME tweaks
      resources      # System monitor
      ptyxis         # Terminal emulator
      pods           # Podman GUI
      impression     # App to create bootable drives

      # Astra Monitor extension
      nethogs
      wirelesstools
      iotop
      libgtop
      pciutils
      # Dependencies
      adwaita-qt6 # for window decorations
      nautilus-python # for collision nautilus extension
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
