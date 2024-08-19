{ pkgs, ... }:

/*
  NOTE:
  ChromaDB for vectorcode.
  A bit bloated, but better off using this over native vectorcode's chroma bs.
*/
{
  services.chromadb = {
    enable = true;
    port = 8181;
    package = pkgs.chromadb-nightly;
  };
}
