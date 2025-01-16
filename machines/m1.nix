# QEMU based default example host
{ ... }:

{
  imports = [
    ../templates
    ../templates/9p.nix
  ];
  networking.hostName = "m1";
  microvm = {
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
  };
}
