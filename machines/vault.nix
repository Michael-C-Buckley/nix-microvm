{pkgs, ...}: {
  networking.hostName = "vault";
  users.users.root.password = "password";
  microvm = {
    # CrosVM is extremely quick and lightwight
    hypervisor = "crosvm";
    socket = "control.socket";

    # The VM idles around 600MB with these production settings
    vcpu = 2;
    mem = 1024;

    interfaces = [
      {
        # Tap interfaces will be available but will need manual `ip` commands to bring the host side interfaces up
        type = "tap";
        id = "vm-vault";
        mac = "02:00:00:ae:7a:21";
      }
    ];

    shares = [
      {
        # 9P works for imperatively run VMs whereas virtiofs needs extra steps
        proto = "9p";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    vault
    openssl
    sops
    rage
    pinentry
    gnupg
    cfssl
  ];

}
