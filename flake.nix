{
  description = "MicroVM Testing";

  nixConfig = {
    extra-substituters = [ "https://microvm.cachix.org" ];
    extra-trusted-public-keys = [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  inputs = {
    # nixpkgs-unstable-small = "";
    microvm = {
      url = "github:Michael-C-Buckley/microvm.nix?ref=fix-kernelAtLeast";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, microvm }:
    let
      system = "x86_64-linux";
    in {
      packages.${system} = {
        default = self.packages.${system}.m1;
        runM2 = self.packages.${system}.m2;
        m1 = self.nixosConfigurations.m1.config.microvm.declaredRunner;
        m2 = self.nixosConfigurations.m2.config.microvm.declaredRunner;
      };

      nixosConfigurations = {
        m1 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit microvm; };
          inherit system;
          modules = [
            microvm.nixosModules.microvm
            ./config
            ./machines/m1.nix
          ];
        };
        m2 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit microvm; };
          inherit system;
          modules = [
            microvm.nixosModules.microvm
            ./machines/m2.nix
          ];
        };
      };
    };
}
