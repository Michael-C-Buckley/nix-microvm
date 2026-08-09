{
  description = "MicroVM Testing";

  # This project uses Tack:
  # https://github.com/manic-systems/tack
  # Inputs are tracked outside of the flake,
  # however, are overridable and the experience is 
  # invisisble to the user
  outputs =
    {
      self,
      ...
    }@args:
    let
      inputs = (import ./.tack) { overrides = args.tackOverrides or { }; };
      # Currently only focused on supporting on Linux systems
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = inputs.nixpkgs.lib.genAttrs systems;
    in
    {
      # The NixOS portion of the VM configuration
      nixosConfigurations = import ./outputs/nixosConfigurations.nix { inherit self systems inputs; };
      # The final piece, since the VM is collected as a package output
      packages = forAllSystems (system: import ./outputs/packages.nix { inherit self system; });
      devShells = forAllSystems (system: import ./outputs/devShell.nix { inherit system inputs; });

    };
}
