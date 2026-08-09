{
  self,
  systems,
  inputs,
}:
let
  inherit (builtins) attrNames listToAttrs;
  inherit (inputs) nixpkgs microvm;

  # These hosts are the base configs that will have each support system configured
  hosts = {
    t1 = [ ../machines/t1.nix ];
    t2 = [ ../machines/t2.nix ];
    vault = [
      ../machines/vault.nix
      ../config/nixos/vault/prod.nix
    ];
    vault-dev = [
      ../machines/vault.nix
      ../config/nixos/vault/dev.nix
    ];
  };

  mkVM =
    {
      system,
      hostname,
    }:
    nixpkgs.lib.nixosSystem {
      specialArgs = { inherit self inputs microvm; };
      inherit system;
      modules = [
        microvm.nixosModules.microvm
        ../config/nixos/common.nix
      ]
      ++ hosts.${hostname};
    };
in
  # Each VM has an associated system type, this function will create a valid NixOS
  #  configuration that each VM by hostname can use.
  # Since the package of the declared runner is detected by package output, therefore
  #  system type, they will map automatically.
  listToAttrs (
    nixpkgs.lib.flatten (
      map (
        hostname:
        map (system: {
          name = "${hostname}-${system}";
          value = mkVM { inherit system hostname; };
        }) systems
      ) (attrNames hosts)
    )
  )
