{ lib, flake, ... }: {
  #https://discourse.nixos.org/t/unable-to-set-custom-xkb-layout/16534/18
  #https://github.com/NixOS/nixpkgs/pull/264787
  services.xserver = {
    xkb = {
      extraLayouts = {
        pp = {
          description = "PPKB Layout (EN)";
          languages = [ "eng" ];
          symbolsFile = "${flake.inputs.ppkb-fix}/xkb/pp";
        };
      };
      layout = "pp";
    };
  };
}
