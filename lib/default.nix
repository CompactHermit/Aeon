{lib, ...}: let
  inherit (builtins) pathExists readDir readFileType elemAt;
  inherit (lib) mkOption types optionals literalExpression mapAttrs concatMapAttrs genAttrs;
  inherit (lib.strings) hasSuffix removeSuffix;

  readModules = dir:
    if pathExists "${dir}.nix" && readFileType "${dir}.nix" == "regular"
    then {default = dir;}
    else if pathExists dir && readFileType dir == "directory"
    then
      concatMapAttrs
      (
        entry: type: let
          dirDefault = "${dir}/${entry}/default.nix";
        in
          if type == "regular" && hasSuffix ".nix" entry
          then {${removeSuffix ".nix" entry} = "${dir}/${entry}";}
          else if pathExists dirDefault && readFileType dirDefault == "regular"
          then {${entry} = dirDefault;}
          else {}
      )
      (readDir dir)
    else {};
in {
  inherit readModules;
}
