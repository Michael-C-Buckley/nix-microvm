{
  description = "MicroVM Testing";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    microvm = {
      url = "git+https://github.com/astro/microvm.nix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "git+https://github.com/Mic92/sops-nix?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    microvm,
    ...
  } @ inputs: let
    systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

    forAllSystems = nixpkgs.lib.genAttrs systems;
    importPkgs = system:
      import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
      };

    system = "x86_64-linux";

    mkVM = modules:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs microvm;};
        inherit system;
        modules =
          [
            microvm.nixosModules.microvm
            ./config/nixos/common.nix
          ]
          ++ modules;
      };
  in {
    devShells = forAllSystems (system: let
      pkgs = importPkgs system;
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          microvm.packages.${system}.microvm
          alejandra
          sops
        ];
      };
    });

    packages = forAllSystems (system: {
      default = self.packages.${system}.m1;
      m1 = self.nixosConfigurations.m1.config.microvm.declaredRunner;
      m2 = self.nixosConfigurations.m2.config.microvm.declaredRunner;
    });

    nixosConfigurations = {
      m1 = mkVM [./machines/m1.nix];
      m2 = mkVM [./machines/m2.nix];
    };
  };
}
