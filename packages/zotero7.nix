{...}:{
  perSystem = {pkgs,...}:{
    packages.zotero7 = pkgs.stdenv.mkDerivation {
      version = "";
    };
  };
}
