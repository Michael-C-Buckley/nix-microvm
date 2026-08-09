{
  self,
  system,
}:
let
  getRunner = name: self.nixosConfigurations."${name}-${system}".config.microvm.declaredRunner;
in
{
  t1 = getRunner "t1";
  t2 = getRunner "t2";
  vault = getRunner "vault";
  vault-dev = getRunner "vault-dev";
}
