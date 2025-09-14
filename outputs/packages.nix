{self, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let 
     getRunner = name: self.nixosConfigurations."${name}-${system}".config.microvm.declaredRunner;
    in {
    packages = {
      m1 = getRunner "m1";
      m2 = getRunner "m2";
      vault = getRunner "vault";
      vault-dev = getRunner "vault-dev";
    };
  };
}
