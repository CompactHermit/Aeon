{ pkgs, lib, flake, ... }:
let
  xkb-faker = pkgs.xorg.xkeyboardconfig.overrideAttrs (oa: {
    postInstall = oa.postInstall + ''
      cp -v ${flake.inputs.ppkb-fix}/xkb/pp $out/share/X11/xkb/symbols/
      cp -v ${flake.inputs.ppkb-fix}/xkb/pp-driver $out/share/X11/xkb/symbols/
      cp -v ${flake.inputs.ppkb-fix}/xkb/evdev.xml $out/share/X11/xkb/rules/
      cp -v ${flake.inputs.ppkb-fix}/xkb/evdev.xml $out/share/X11/xkb/rules/base.xml
      cp -v ${flake.inputs.ppkb-fix}/xkb/evdev.lst $out/share/X11/xkb/rules/
      cp -v ${flake.inputs.ppkb-fix}/xkb/evdev.lst $out/share/X11/xkb/rules/base.lst
    '';
  });
in {
  #https://discourse.nixos.org/t/unable-to-set-custom-xkb-layout/16534/18
  #https://github.com/NixOS/nixpkgs/pull/264787
  services.xserver = {
    xkb = {
      extraLayouts = {
        pp = {
          description = "PPKB Layout (EN)";
          languages = [ "eng" ];
          symbolsFile = "${xkb-faker}/share/X11/xkb/symbols/pp";
        };
      };
      dir = "${xkb-faker}/etc/X11/xkb";
      layout = "pp";
    };
  };
  #https://github.com/NixOS/nixpkgs/pull/138207 works, IDK fml
  environment.sessionVariables = {
    XKB_CONFIG_ROOT = "${xkb-faker}/etc/X11/xkb";
  };
}
