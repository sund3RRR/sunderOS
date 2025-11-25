{
  pkgs,
  ...
}:
{ 
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  services.flatpak.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverrides = ''
      # Set GDM display scaling factor to 2x (for HiDPI displays)
      [org.gnome.desktop.interface]
      scaling-factor=2

      # Increase timeout for compositor's alive check (30 seconds)
      [org.gnome.mutter]
      check-alive-timeout=30000
      experimental-features=['scale-monitor-framebuffer', 'xwayland-native-scaling']

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

  programs.dconf.enable = true;

  services.gnome.gnome-remote-desktop.enable = true;

  services.printing.enable = true;

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
      adw-gtk3
      nautilus-python # for collision nautilus extension
    ]
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      arcmenu
      astra-monitor
      blur-my-shell
      caffeine
      clipboard-history
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
