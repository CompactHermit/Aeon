{pkgs, lib, ...}:
  pkgs.stdenv.mkDerivation {
  pname = "oxocarbon-gtk";
  version = "0.0.1";

  src = ./oxocarbon-gtk;

  sourceRoot = ".";

  propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes
    cp -a ./oxocarbon-gtk* $out/share/themes
    runHook postInstall
    '';
  }
