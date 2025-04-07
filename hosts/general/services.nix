{
  pkgs,
  ...
}:
{
  systemd.packages = with pkgs; [
    lact
  ];

  services.udev.packages = with pkgs; [
    ddcutil
  ];

  services.dbus.packages = with pkgs; [ ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  systemd.services."lactd".wantedBy = [ "multi-user.target" ];

  services.flatpak.enable = true;
  services.avahi.enable = true;
  services.logind.suspendKey = "ignore";

  # Enable CUPS to print documents.
  services.printing.enable = true;
}