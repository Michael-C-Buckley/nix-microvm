{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        inputs.microvm.packages.${system}.microvm
        alejandra
        sops
      ];
    };
  };
}
