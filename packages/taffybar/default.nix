{...}: {
  # Just shameless copying Snowflake (-_-)
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    packages.hermit-bar =
      pkgs.haskell.lib.addPkgconfigDepends
      (pkgs.haskellPackages.callCabal2nix "hermitbar" ./. {}) (with pkgs; [
        fribidi.dev
        fribidi.out
        hostname
        libdatrie.dev
        libepoxy.dev
        libselinux.dev
        libsepol.dev
        libthai.dev
        libxkbcommon.dev
        pcre
        pcre2
        util-linux.dev
        xorg.libXdmcp.dev
        xorg.libXtst.out
      ]);
  };
}
