# QEMU based default example host
{ ... }:

{
  networking.hostName = "m1";
  users.users.root.password = "";
  microvm = {
    hypervisor = "qemu";
    socket = "control.socket";

    interfaces = [
      {
        type = "tap";
        id = "vm-m1";
        mac = "02:00:00:00:00:01";
      }
    ];

    volumes = [ {
      mountPoint = "/var";
      image = "m1.img";
      size = 256;
    } ];

    shares = [ {
      # use proto = "virtiofs" for MicroVMs that are started by systemd
      proto = "9p";
      tag = "ro-store";
      # a host's /nix/store will be picked up so that no
      # squashfs/erofs will be built for it.
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    } ];
  };
}
