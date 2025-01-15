# Firecracker Example
#
{
  networking.hostName = "m2";
  users.users.root.password = "";
    microvm = {
      hypervisor = "cloud-hypervisor";
      socket = "control.socket";
      mem = 512;
      vcpu = 1;

      volumes = [ {
        mountPoint = "/var";
        image = "m2.img";
        size = 256;
      } ];

      # kernelParams = [ "console=ttyS0" ];

      interfaces = [
        {
          type = "tap";
          id = "vm-m2";
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
