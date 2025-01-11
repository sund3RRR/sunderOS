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
    flakelight ./. {
      inherit inputs;

      overlay = (import ./pkgs/overlay.nix);

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
              { nixpkgs.overlays = [ (import ./pkgs/overlay.nix) ]; }
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
              { nixpkgs.overlays = [ (import ./pkgs/overlay.nix) ]; }
              {
                _module.args.unstable = import inputs.nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              }
            ];
          };
      };

      formatter = pkgs: pkgs.nixfmt-rfc-style;
    };
}
