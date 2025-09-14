# A common config base to be shared among all project VMs
{pkgs, ...}: {
  # I use unfree but this may be changed, which may require users handle accordingly
  nixpkgs.config.allowUnfree = true;
  # This is just for convenience sake
  environment.enableAllTerminfo = true;

  users.users.root.password = "password";

  system.stateVersion = "25.11";

  environment.systemPackages = with pkgs; [
    curl
    gitMinimal
    microfetch
    neovim
  ];

  # Some useful defaults
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
