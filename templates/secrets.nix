{inputs, ...}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  # To generate host keys (which appear to remain static)
  services.sshd.enable = true;

  microvm.shares = [
    {
      proto = "9p";
      tag = "ssh";
      source = "${inputs.self}/secrets/keys";
      mountPoint = "/etc/age";
    }
  ];

  fileSystems."/etc/age".neededForBoot = true;

  sops = {
    defaultSopsFile = ../secrets/test.yaml;
    age.keyFile = "/etc/age/keys.txt";
    secrets = {
      key1 = {};
      key2 = {};
    };
  };
}
