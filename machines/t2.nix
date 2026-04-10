# Firecracker Example
#
{
  networking.hostName = "t2";
  microvm = {
    hypervisor = "cloud-hypervisor";
    socket = "control.socket";
    mem = 512;
    vcpu = 1;

    volumes = [
      {
        mountPoint = "/var";
        image = "t2.img";
        size = 256;
      }
    ];

    # kernelParams = [ "console=ttyS0" ];

    interfaces = [
      {
        type = "tap";
        id = "vm-t2";
        mac = "02:00:00:00:00:02";
      }
    ];

    # shares = [ {
    #   proto = "9p";
    #   tag = "ro-store";
    #   source = "/nix/store";
    #   mountPoint = "/nix/.ro-store";
    # } ];
  };
}
