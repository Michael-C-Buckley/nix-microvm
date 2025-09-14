_: {
  # Currently this is a testing edition and needs production changes
  services.vault = {
    enable = true;
    address = "0.0.0.0:8200";
    listenerExtraConfig = ''
      tls_disable = 1
    '';

    storageBackend = "raft";
    storageConfig = ''
      path = "/vault"
      node_id = "node1"
    '';

    extraConfig = ''
      ui = true

      api_addr = "http://localhost:8200"

      # Cluster address must be set when using raft
      cluster_addr = "http://127.0.0.1:8201"
    '';
  };

  # Give the production unit a persistent file store
  microvm.volumes = [
    {
      mountPoint = "/vault";
      image = "vault.img";
      size = 512;
    }
  ];

  # Change the persmissions for the directory
  systemd.tmpfiles.rules = [
    "d /vault 0750 vault vault -"
  ];
}
