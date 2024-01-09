{ stdenv }:
stdenv.mkDerivation {
  pname = "icomoon-glyphs";
  version = "0.0.1";
  src = ./fonts;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/truetype
    cp icomoon.ttf $out/share/fonts/truetype
    runHook postInstall
  '';
}
