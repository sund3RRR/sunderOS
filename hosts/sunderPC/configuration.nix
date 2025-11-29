# MECHREVO WUJIE-14X
{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix

    ../general/fhs-compat.nix
    ../general/gaming.nix
    ../general/gnome.nix
    ../general/networking.nix
    ../general/nix-config.nix
    ../general/prismlauncher-overlay.nix
    ../general/programs.nix
    ../general/virtualisation.nix
  ];

  sunderOS = {
    zapret = {
      enable = true;
      strategy = "general_ALT2";
    };

    bootloader.oemLogo.enable = true;

    bootloader.limine = {
      enable = true;
      secureBoot = true;
      rememberLastEntry = true;
      entries = {
        windows.enable = true;
        windows.resource = "guid(f9bb782b-1fa8-4a47-a8ef-72a47e1e0caf)";
        memtest86.enable = true;
      };
    };
  };

  services.lact.enable = true;

  qt = {
    enable = true;
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
    wl-clipboard # for micro
    nautilus-python # for collision nautilus extension
    zenity # for mailspring notifications
  ];

  system.stateVersion = "25.11";
}
