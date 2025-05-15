# A common config base to be shared among all project VMs

{ pkgs, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_6_13_hardened;
  nixpkgs.config.allowUnfree =  true;
  environment.enableAllTerminfo = true;
  system.stateVersion = "25.05";

  environment.systemPackages = with pkgs; [
    microfetch
    vim
  ];

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
