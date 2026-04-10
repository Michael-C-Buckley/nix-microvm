# QEMU based default example host
{
  imports = [
    ../templates
    ../templates/9p.nix
    ../templates/secrets.nix
  ];
  networking.hostName = "t1";
  microvm = {
    interfaces = [
      {
        type = "tap";
        id = "vm-t1";
        mac = "02:00:00:00:00:01";
      }
    ];
    volumes = [
      {
        mountPoint = "/var";
        image = "t1.img";
        size = 256;
      }
    ];
  };
}
