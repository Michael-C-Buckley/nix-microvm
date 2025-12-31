{
  description = "MicroVM Testing";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
    flake-parts,
    ...
  } @ inputs: let
    # Currently only supported on Linux systems
    systems = ["x86_64-linux" "aarch64-linux"];
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      inherit systems;

      # Specific outputs are defined elsewhere, aligned by their name
      imports = [
        ./outputs/devShells.nix
        # The NixOS portion of the VM configuration
        ./outputs/nixosConfigurations.nix
        # The final piece, since the VM is collected as a package output
        ./outputs/packages.nix
      ];

      flake.hydraJobs = {
        inherit (self) packages devShells;
      };
    };
}
