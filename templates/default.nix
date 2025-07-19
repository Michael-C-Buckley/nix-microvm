# Default QEMU Template
# QEMU based default example host
{lib, ...}: {
  users.users.root.password = lib.mkDefault "";
  microvm = {
    hypervisor = "qemu";
    socket = lib.mkDefault "control.socket";
  };
}
