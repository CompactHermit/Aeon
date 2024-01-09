{ pkgs, ... }:
pkgs.stdenv.mkDerivation rec {
  pname = "Arxiv-Terminal";
  version = "v0.3.1";
  src = pkgs.fetchFromGitHub {
    owner = "jbencina";
    repo = "arxivterminal";
    rev = "cc1b12f04e534232cf730d7e8e5ca7d956d53f9c";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
}
