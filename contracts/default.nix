{ lib, self, ... }:
#TODO:: Fix This dogshit
let
  #inherit (lib.attrsets) ;
  inherit (builtins) attrValues readDir;
in
(attrValues (readDir ./.))
