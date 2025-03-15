{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.libinput-config;
  generateConf = attrs: builtins.concatStringsSep "\n" (map (key: "${key}=${attrs.${key}}") (builtins.attrNames attrs));
in
{
  options.libinput-config = {
    enable = lib.mkEnableOption "libinput-config module";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.libinput-config;
      description = "Package to use for libinput-config";
    };
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        'libinput-config' settings
        The options are:
          override-compositor={disabled,enabled}
          tap={disabled,enabled}
          tap-button-map={lrm,lmr}
          drag={disabled,enabled}
          drag-lock={disabled,enabled}
          accel-speed=[number]
          accel-profile={none,flat,adaptive}
          natural-scroll={disabled,enabled}
          left-handed={disabled,enabled}
          click-method={none,button-areas,clickfinger}
          middle-emulation={disabled,enabled}
          scroll-method={none,two-fingers,edge,on-button-down}
          scroll-button=[number]
          scroll-button-lock={disabled,enabled}
          dwt={disabled,enabled}
          scroll-factor=[number]
          scroll-factor-x=[number]
          scroll-factor-y=[number]
          discrete-scroll-factor=[number]
          discrete-scroll-factor-x=[number]
          discrete-scroll-factor-y=[number]
          speed=[number]
          speed-x=[number]
          speed-y=[number]
          gesture-speed=[number]
          gesture-speed-x=[number]
          gesture-speed-y=[number]
          remap-key=[number]:[number]
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];

    environment.sessionVariables.LD_PRELOAD = [
      "${cfg.package}/lib/libinput-config.so"
    ];

    environment.etc."libinput.conf".text = generateConf cfg.settings;
  };
}