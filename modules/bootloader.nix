{ lib, pkgs, ... }:
let
  cfg = config.sunderOS.bootloader;
in
{
  options.sunderOS.bootloader = {
    limine = {
      enable = lib.mkEnableOption "Enable Limine bootloader";
      secureBoot = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      timeout = lib.mkOption {
        type = lib.types.str;
        default = "5";
      };
      rememberLastEntry = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      entries.windows.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      entries.windows.resource = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      entries.memtest86.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      wallpapers = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ pkgs.nixos-artwork.wallpapers.nineish-catppuccin-mocha-alt.gnomeFilePath ];
      };
    };
    oemLogo = {
      enable = lib.mkEnableOption "Enable OEM logo (BGRT via Plymouth)";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.limine.enable {
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine = {
        enable = true;
        secureBoot.enable = cfg.limine.secureBoot;

        extraConfig = ''
          timeout: ${cfg.limine.timeout}
          remember_last_entry: ${if cfg.limine.rememberLastEntry then "yes" else "no"}
        '';

        extraEntries = lib.concatStringsSep "\n" ([
          (lib.optionalString cfg.limine.entries.windows.enable ''
            /Windows
              protocol: efi
              path: ${cfg.limine.entries.windows.resource}:/EFI/Microsoft/Boot/bootmgfw.efi
          '')
          (lib.optionalString cfg.limine.entries.memtest86.enable ''
            /Memtest86+
              protocol: efi
              path: boot():/limine/memtest86/memtest86.efi
          '')
        ]);

        additionalFiles = lib.mkMerge [
          (lib.optionalAttrs cfg.limine.entries.memtest86.enable {
            "memtest86/memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
          })
        ];

        style = {
          wallpapers = cfg.limine.wallpapers;
        };
      };
    })
    (lib.mkIf cfg.oemLogo.enable {
      boot.plymouth = {
        enable = true;
        theme = "bgrt";
      };
    })
  ];
}
