# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./boot.nix
    ./filesystems.nix
    ./hardware.nix
    ./networking.nix
    ./nix-config.nix
    ./virtualisation.nix
    ./xremap.nix
    ./gnome.nix
    ./touchpad.nix
    ./programs
    ./services
  ];

  nixld.enable = true;
  zapret.enable = true;
  gaming.enable = true;

  qt = {
    enable = true;
    #platformTheme = "gnome";
    #style = "adwaita-dark";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  services.xserver.enable = true;

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

  users.users.sunder = {
    isNormalUser = true;
    description = "sunder";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
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
    distrobox
    fastfetch
    git
    htop
    tree
    nixfmt-rfc-style
    micro
    s-tui
    wget

    # Desktop apps
    brave
    vscode
    lact
    prismlauncher
    zed-editor

    # Dependencies
    adwaita-qt6 # for window decorations
    ddcutil # for brightness extension
    firefoxpwa # for firefox pwa
    wl-clipboard # for micro
    
    # Themes
    adw-gtk3
    whitesur-gtk-theme
  ];

  system.stateVersion = "25.05";
}
