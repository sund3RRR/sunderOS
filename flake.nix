{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tuxedo-nixos.url = "github:sund3RRR/tuxedo-nixos/dev";
    xremap-flake.url = "github:xremap/nix-flake";
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
            linuxMechrevo = final.linuxPackages.extend (
              lpself: lpsuper: {
                tuxedo-drivers = prev.linuxPackages.callPackage ./pkgs/mechrevo-drivers { };
              }
            );
            kdePackages = prev.kdePackages.overrideScope (
              kpfinal: kpprev: {
                kwin = kpprev.kwin.overrideAttrs (
                  finalAttrs: prevAttrs: {
                    postPatch =
                      prevAttrs.postPatch
                      + ''
                        substituteInPlace src/virtualdesktops.cpp \
                          --replace-fail "input()->registerAxisShortcut(Qt::MetaModifier | Qt::AltModifier, PointerAxisDown," \
                            "input()->registerAxisShortcut(Qt::MetaModifier, PointerAxisUp," \
                          --replace-fail "input()->registerAxisShortcut(Qt::MetaModifier | Qt::AltModifier, PointerAxisUp," \
                            "input()->registerAxisShortcut(Qt::MetaModifier, PointerAxisDown,"
                      '';
                  }
                );
              }
            );
          };
      in
      {
        inherit inputs;

        systems = lib.intersectLists lib.systems.doubles.linux lib.systems.flakeExposed;

        formatter = pkgs: pkgs.nixfmt-rfc-style;
        overlay = pkgs-overlay;

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
            in
            {
              inherit system;
              modules = [
                ./sunderPC/configuration.nix
                ./modules/gaming.nix
                { nixpkgs.overlays = [ pkgs-overlay ]; }
                {
                  _module.args.unstable = import inputs.nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                }
              ];
            };
          sunderBook =
            let
              system = "x86_64-linux";
            in
            {
              inherit system;
              modules = [
                ./sunderBook/configuration.nix
                ./modules/gaming.nix
                ./modules/fhs-compat.nix
                ./modules/zapret.nix
                inputs.tuxedo-nixos.nixosModules.default
                inputs.xremap-flake.nixosModules.default
                {
                  nixpkgs.overlays = [
                    pkgs-overlay
                    #inputs.tuxedo-nixos.overlays.default
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
          sunderArmVM =
            let
              system = "aarch64-linux";
            in
            {
              inherit system;
              modules = [
                ./sunderArmVM/configuration.nix
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
