{
  pkgs,
  ...
}:
{
  # Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub = {
  #   enable = true;
  #   efiSupport = true;
  #   device = "nodev";
  #   useOSProber = true;
  #   splashImage = null;
  #   theme = pkgs.elegant-grub-theme.override {
  #     theme = "forest";
  #     type = "float";
  #     side = "left";
  #     color = "dark";
  #     resolution = "4k";
  #     logo = "Nixos";
  #   };
  # };
  
  boot.loader.limine = {
    enable = true;
    extraConfig = ''
      timeout: 5
      remember_last_entry: yes
    '';
    extraEntries = ''
      /Windows
        protocol: efi
        path: guid(f9bb782b-1fa8-4a47-a8ef-72a47e1e0caf):/EFI/Microsoft/Boot/bootmgfw.efi
      /Memtest86+
        protocol: efi
        path: boot():/limine/memtest86/memtest86.efi
    '';
    additionalFiles = {
      "memtest86/memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
    };
    style = {
      wallpapers = [
        pkgs.nixos-artwork.wallpapers.nineish-catppuccin-mocha-alt.gnomeFilePath
      ];
    };
  };

  # Plymouth
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };
}
