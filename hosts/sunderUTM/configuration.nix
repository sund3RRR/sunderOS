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
    ../general/fhs-compat.nix
    ../general/gnome.nix
    ../general/networking.nix
    ../general/nix-config.nix
    ../general/programs.nix
  ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

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
    code-cursor

    # Dependencies
    wl-clipboard # for micro
    nautilus-python # for collision nautilus extension
  ];

  system.stateVersion = "25.11";
}
