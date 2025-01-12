{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/3f0a8ac25fb6";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flakelight = {
      url = "github:nix-community/flakelight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. (
      let
        pkgs-overlay =
          final: prev:
          builtins.listToAttrs (
            map (pkg: {
              name = pkg;
              value = final.callPackage ./pkgs/${pkg} { };
            }) (builtins.attrNames (builtins.readDir ./pkgs))
          );
      in
      {
        inherit inputs;

        formatter = pkgs: pkgs.nixfmt-rfc-style;
        overlay = pkgs-overlay;

        packages =
          let
            discoverPackages = builtins.attrNames (builtins.readDir ./pkgs);
          in
          builtins.listToAttrs (
            map (pkg: {
              name = pkg;
              value = import ./pkgs/${pkg};
            }) discoverPackages
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
                ./modules/amnezia-vpn.nix
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
              system = "aarch64-linux";
            in
            {
              inherit system;
              modules = [
                ./sunderBook/configuration.nix
                ./modules/amnezia-vpn.nix
                { nixpkgs.overlays = [ pkgs-overlay ]; }
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
