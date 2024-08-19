{ lib, ... }:
{
  imports = [
    ./ssl.nix
    ./arxiv.nix
    ./home.nix
    ./ddns.nix
    ./multimedia.nix
  ];
}
