{ lib, ... }:
let
  inherit (builtins) pathExists readDir readFileType;
  inherit (lib) concatMapAttrs;
  inherit (lib.strings) hasSuffix removeSuffix;
in
{
  /*
    *
    listEntries:: (Path a) -> [Paths]
  */
  listEntries = path: map (name: path + "/${name}") (builtins.attrNames (builtins.readDir path));

  /*
    *
    readModules:: (Path a) -> {"a" = toNixStorePath;}
    Reads a directory, and returns a recursive import of the directories
  */
  readModules =
    dir:
    if pathExists "${dir}.nix" && readFileType "${dir}.nix" == "regular" then
      {
        default = dir;
      }
    else if pathExists dir && readFileType dir == "directory" then
      concatMapAttrs (
        entry: type:
        let
          dirDefault = "${dir}/${entry}/default.nix";
        in
        if type == "regular" && hasSuffix ".nix" entry then
          {
            ${removeSuffix ".nix" entry} = "${dir}/${entry}";
          }
        else if pathExists dirDefault && readFileType dirDefault == "regular" then
          {
            ${entry} = dirDefault;
          }
        else
          { }
      ) (readDir dir)
    else
      { };
}
