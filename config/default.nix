{ pkgs, ... }: {
  nixpkgs.config.allowUnfree =  true;
  environment.enableAllTerminfo = true;

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
