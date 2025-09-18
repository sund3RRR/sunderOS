# UTM aarch64 Virtual Machine
{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix

    ../general/boot.nix
    #../general/gnome.nix
    ../general/networking.nix
    ../general/nix-config.nix
    ../general/programs.nix
    ../general/services.nix
  ];

  nixld.enable = true;

  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  qt = {
    enable = true;
  };

  # xdg.portal = {
  #   enable = true;
  #   xdgOpenUsePortal = true;
  # };

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
    btop
    curl
    fastfetch
    git
    htop
    tree
    nixfmt-rfc-style
    micro
    s-tui
    wget
    python3

    # Desktop apps
    vscode
    zed-editor

    # Dependencies
    adwaita-qt6 # for window decorations
    wl-clipboard # for micro
    nautilus-python # for collision nautilus extension

    # Themes
    adw-gtk3
    whitesur-gtk-theme # bug
  ];

  system.stateVersion = "25.05";
}
