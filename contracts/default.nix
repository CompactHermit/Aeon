{ lib, self, ... }:
let
  inherit (lib.attrsets) foldAttrs;
  inherit (builtins) attrValues readDir;
in (attrValues (readDir ./.))
