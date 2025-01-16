{ pkgs, ... }: {
  nixpkgs.config.allowUnfree =  true;
  environment.enableAllTerminfo = true;

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
        "auto-allocate-uids"
      ];
    };
  };
}
