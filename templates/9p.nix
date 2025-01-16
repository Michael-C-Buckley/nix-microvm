# QEMU based default example host
{ ... }:

{
  microvm = {
    shares = [ {
      proto = "9p";
      tag = "ro-store";
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
    } ];
  };
}
