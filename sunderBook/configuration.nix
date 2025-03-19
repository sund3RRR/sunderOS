# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  config,
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
    ./programs.nix
    ./services.nix
  ];

  nixld.enable = true;
  zapret.enable = true;
  gaming.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      code-cursor = (
        let
          appimageContents = prev.appimageTools.extractType2 {
            inherit (prev.code-cursor) version pname;
            src = prev.code-cursor.sources.${config.nixpkgs.hostPlatform.system};
            postExtract = ''
              find $out -type f -name '*.js' \
                -exec grep -l ,minHeight {} \; \
                -exec sed -i 's/,minHeight/,frame:false,minHeight/g' {} \;
            '';
          };
        in
        prev.appimageTools.wrapAppImage {
          inherit (prev.code-cursor) pname version;
          src = appimageContents;

          nativeBuildInputs = [ prev.makeWrapper ];

          extraInstallCommands = ''
            mkdir -p $out/share/cursor $out/share/applications/
            cp -a ${appimageContents}/locales $out/share/cursor
            cp -a ${appimageContents}/usr/share/icons $out/share/
            install -Dm 644 ${appimageContents}/cursor.desktop -t $out/share/applications/

            substituteInPlace $out/share/applications/cursor.desktop --replace-fail "AppRun" "cursor"

            wrapProgram $out/bin/cursor \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}} --no-update"
          '';

          passthru = prev.code-cursor.passthru;
        }
      );
    })
  ];

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
    GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
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
    pciutils

    # Desktop apps
    brave
    vscode
    lact
    prismlauncher
    zed-editor
    code-cursor

    # Dependencies
    adwaita-qt6 # for window decorations
    ddcutil # for brightness extension
    firefoxpwa # for firefox pwa
    wl-clipboard # for micro
    nautilus-python # for collision nautilus extension
    nethogs # for astra monitor extension
    wirelesstools # for astra monitor extension
    iotop # for astra monitor extension
    libgtop # for astra monitor extension

    # Themes
    adw-gtk3
    whitesur-gtk-theme
  ];

  system.stateVersion = "25.05";
}
