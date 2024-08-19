{
  pkgs,
  flake,
  config,
  lib,
  ...
}:
let
  emc = pkgs.writeShellScriptBin "em" ''
    #!/bin/sh
    emacsclient -nc $@
  '';
in
{
  home = {
    packages = [ emc ];
  };
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };
  services.emacs.enable = true;
}
