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
  ];

  nixld.enable = true;
  zapret.enable = true;
  programs.gaming.enable = true;

  libinput-config = {
    enable = true;
    settings = {
      override-compositor = "enabled";
      scroll-factor = "0.5";
      gesture-speed-x = "1.5";
      accel-profile = "adaptive"; # {none,flat,adaptive}
    };
  };

  qt = {
    enable = true;
    #platformTheme = "gnome";
    #style = "adwaita-dark";
  };

  programs.amnezia-vpn.enable = true;
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/sunderOS#sunderBook";
    };
  };

  programs.dconf.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.flatpak.enable = true;
  services.avahi.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.

  services.udev.packages = with pkgs; [ ddcutil ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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

  # Install firefox.
  programs.firefox.enable = true;
  programs.firefox.nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];

  # Allow unfree packages

  fonts.packages = with pkgs; [ meslo-lgs-nf ];

  systemd.packages = [ pkgs.lact ];
  systemd.services."lactd".wantedBy = [ "multi-user.target" ];

  environment.variables = {
    #NIXOS_OZONE_WL = "1";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    micro
    wl-clipboard
    htop
    btop
    s-tui
    fastfetch
    git
    wget
    curl
    tree
    nixfmt-rfc-style
    distrobox

    brave
    vscode
    firefoxpwa
    zed-editor
    lact
    prismlauncher
    
    whitesur-gtk-theme
    adwaita-qt6
    gnome-tweaks
    adw-gtk3
    ddcutil
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
