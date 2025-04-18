# MECHREVO WUJIE-14X
{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./input.nix

    ../general/boot.nix
    ../general/cursor-overlay.nix
    ../general/gnome.nix
    ../general/networking.nix
    ../general/nix-config.nix
    ../general/prismlauncher-overlay.nix
    ../general/programs.nix
    ../general/services.nix
    ../general/virtualisation.nix
  ];

  nixld.enable = true;
  zapret.enable = true;
  gaming.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-32.3.3"
  ];

  programs.hyprland.enable = true;

  services.power-profiles-daemon.enable = true;

  qt = {
    enable = true;
    # platformTheme = "gnome";
    # style = "adwaita-dark";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

  security.rtkit.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [ meslo-lgs-nf ];

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    # Terminal
    amdgpu_top
    btop
    curl
    dig
    distrobox
    fastfetch
    git
    glxinfo
    htop
    tree
    nixfmt-rfc-style
    nix-search
    micro
    inxi
    s-tui
    wget
    python3
    hyprpanel

    # Desktop apps
    #code-cursor
    xpipe
    vscode
    lact
    mailspring
    zed-editor
    prismlauncher

    # Dependencies
    ddcutil # for brightness extension
    firefoxpwa # for firefox pwa
    wl-clipboard # for micro
    zenity # for mailspring notifications

    # Themes
    adw-gtk3
    whitesur-gtk-theme
    orchis-theme

    fluent-icon-theme
    qogir-icon-theme
    tela-icon-theme
  ];

  system.stateVersion = "25.05";
}
