{pkgs,...}:{
  home.packages = with pkgs; [
    attic
  ];

  # TODO:: Add attic cache token here
  # nix.settings = {
  #   extra-substituters = []; # ADD attic token here
  #   extra-trusted-public-keys = []; # Add key here
  # };


  ## TODO:: Setup SystemD service for Attic, with sops.nix keys
  # systemd.user.services.attic-watch-store = {
  #   Unit = {
  #     Description = "Push Changes to the Binary Cache";
  #   };
  # };
}
