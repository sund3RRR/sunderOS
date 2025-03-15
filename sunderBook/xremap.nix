{
  config,
  pkgs,
  ...
}:
{
  services.xremap = {
    enable = true;
    withGnome = true;
    # withSway = false;
    # withGnome = false;
    # withX11 = false;
    # withHypr = false;
    # withWlroots = false;
    # withKDE =false;

    serviceMode = "user"; # ["user", "system"]
    userName = "sunder";
  };
  # Modmap for single key rebinds
  services.xremap.config.modmap = [
    {
      name = "Global";
      remap = {
        "KEY_RIGHTCTRL" = "KEY_PAGEDOWN";
        "KEY_RIGHTALT" = "KEY_PAGEUP";
        "KEY_INSERT" = "KEY_PRINT";
      };
      device = {
        "only" = "/dev/input/event0";
      };
    }
  ];
  systemd.user.services.xremap.wantedBy = [ "multi-user.target" ];
}
