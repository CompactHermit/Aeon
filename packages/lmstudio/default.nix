{
  lib,
  stdenv,
  callPackage,
  ...
}@args:
let
  pname = "lmstudio";
  version_x86_64-linux = "0.3.15-10";
  hash_x86_64-linux = "sha256-0QPpsGeu3hb0l074e4/FRm44h4BDe82bQTvtqQ3ccks=";
  meta = {
    description = "LM Studio is an easy to use desktop app for experimenting with local and open-source Large Language Models (LLMs)";
    homepage = "https://lmstudio.ai/";
    license = lib.licenses.unfree;
    mainProgram = "lm-studio";
    maintainers = with lib.maintainers; [ crertel ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    broken = stdenv.hostPlatform.isDarwin; # Upstream issue: https://github.com/lmstudio-ai/lmstudio-bug-tracker/issues/347
  };
in
callPackage ./linux.nix {
  inherit pname meta;
  version = version_x86_64-linux;
  url =
    args.url
      or "https://installers.lmstudio.ai/linux/x64/${version_x86_64-linux}/LM-Studio-${version_x86_64-linux}-x64.AppImage";
  hash = args.hash or hash_x86_64-linux;
}
