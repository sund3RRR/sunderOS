# MECHREVO WUJIE-14X
{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix

    ../general/boot.nix
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

  qt = {
    enable = true;
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

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

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
    #NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    # Terminal
    amdgpu_top
    btop
    curl
    distrobox
    fastfetch
    git
    htop
    tree
    nixfmt-rfc-style
    micro
    s-tui
    wget
    python3
    sbctl

    # Desktop apps
    vscode
    lact
    mailspring
    zed-editor
    prismlauncher
    discord

    # Dependencies
    adwaita-qt6 # for window decorations
    ddcutil # for brightness extension
    firefoxpwa # for firefox pwa
    wl-clipboard # for micro
    nautilus-python # for collision nautilus extension
    zenity # for mailspring notifications

    # Themes
    adw-gtk3
    andromeda-gtk-theme # bug
    colloid-gtk-theme
    fluent-gtk-theme # bug
    vimix-gtk-themes
    tokyonight-gtk-theme
    lavanda-gtk-theme
    matcha-gtk-theme
    whitesur-gtk-theme # bug
  ];

  system.stateVersion = "25.11";
}
