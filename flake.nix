{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos";
    xremap-flake.url = "github:xremap/nix-flake";
    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. (
      { lib, ... }:
      let
        pkgs-overlay =
          final: prev:
          builtins.listToAttrs (
            map (pkg: {
              name = pkg;
              value = final.callPackage ./pkgs/generic/${pkg} { };
            }) (builtins.attrNames (builtins.readDir ./pkgs/generic))
          )
          // {
            linuxMechrevo = final.linuxPackages_latest.extend (
              lpself: lpsuper: {
                tuxedo-drivers = prev.linuxPackages_latest.callPackage ./pkgs/mechrevo-drivers { };
              }
            );
          };
      in
      {
        inherit inputs;

        systems = lib.intersectLists lib.systems.doubles.linux lib.systems.flakeExposed;

        formatter = pkgs: pkgs.nixfmt-rfc-style;
        overlays.default = pkgs-overlay;

        packages =
          { system, ... }:
          builtins.listToAttrs (
            map (pkg: {
              name = pkg;
              value = import ./pkgs/generic/${pkg};
            }) (builtins.attrNames (builtins.readDir ./pkgs/generic))
          );

        nixosConfigurations = {
          sunderPC =
            let
              system = "x86_64-linux";
              username = "sund3rrr";
              hostname = "sund3RRR_PC";
            in
            {
              inherit system;
              modules = [
                ./hosts/sunderPC/configuration.nix
                ./modules/bootloader.nix
                ./modules/zapret.nix
                { nixpkgs.overlays = [ pkgs-overlay ]; }
                {
                  _module.args.unstable = import inputs.nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true; 
                  };
                  _module.args.username = username;
                  _module.args.hostname = hostname;
                  _module.args.system = system;
                }
              ];
            };
          sunderBook =
            let
              system = "x86_64-linux";
              username = "sund3rrr";
              hostname = "sunderBook";
            in
            {
              inherit system;
              modules = [
                ./hosts/sunderBook/configuration.nix
                ./modules/bootloader.nix
                # ./modules/zapret.nix
                ./modules/libinput-config.nix
                inputs.tuxedo-nixos.nixosModules.default
                inputs.xremap-flake.nixosModules.default
                {
                  nixpkgs.overlays = [
                    pkgs-overlay
                  ];
                }
                {
                  _module.args.unstable = import inputs.nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                  _module.args.username = username;
                  _module.args.hostname = hostname;
                  _module.args.system = system;
                }
              ];
            };
          sunderUTM =
            let
              system = "aarch64-linux";
              username = "sund3rrr";
              hostname = "sunderUTM";
            in
            {
              inherit system;
              modules = [
                ./hosts/sunderUTM/configuration.nix
                ./modules/bootloader.nix
                ./modules/zapret.nix
                {
                  nixpkgs.overlays = [ pkgs-overlay ];
                }
                {
                  _module.args.unstable = import inputs.nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                  _module.args.username = username;
                  _module.args.hostname = hostname;
                  _module.args.system = system;
                }
              ];
            };
          sunderVMware =
            let
              system = "aarch64-linux";
            in
            {
              inherit system;
              modules = [
                ./hosts/sunderArmVM/configuration.nix
                {
                  nixpkgs.overlays = [
                    pkgs-overlay
                  ];
                }
                {
                  _module.args.unstable = import inputs.nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                }
              ];
            };
        };
      }
    );
}
