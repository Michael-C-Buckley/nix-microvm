{ system, inputs }:
let
  pkgs = import inputs.nixpkgs { inherit system; };
in
{
  default = pkgs.mkShellNoCC {
    packages = with pkgs; [
      inputs.microvm.packages.${system}.microvm
      alejandra
      sops
    ];
  };
}
