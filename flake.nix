{
  description = "MicroVM Testing";

  nixConfig = {
    extra-substituters = [ "https://microvm.cachix.org" ];
    extra-trusted-public-keys = [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  inputs = {
    nixpkgs.follows = "microvm/nixpkgs";
    microvm.url = "github:astro/microvm.nix";
  };

  outputs = { self, nixpkgs, microvm }:
    let
      system = "x86_64-linux";

      mkVM = modules: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit microvm; };
        inherit system;
        modules = [
          microvm.nixosModules.microvm
          ./config/nixos/common.nix
        ] ++ modules;
      };
    in {
      packages.${system} = {
        default = self.packages.${system}.m1;
        m1 = self.nixosConfigurations.m1.config.microvm.declaredRunner;
        m2 = self.nixosConfigurations.m2.config.microvm.declaredRunner;
      };

      nixosConfigurations = {
        m1 = mkVM [./machines/m1.nix ./config/nixos/smallstep.nix];
        m2 = mkVM [./machines/m2.nix];
      };
    };
}
