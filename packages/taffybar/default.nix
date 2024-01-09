{ haskell, fribidi, haskellPackages, hostname, libdatrie, libepoxy, libselinux
, libsepol, libthai, libxkbcommon, pcre, pcre2, util-linux, xorg, ... }:
haskell.lib.addPkgconfigDepends
(haskellPackages.callCabal2nix "hermitbar" ./. { }) [
  fribidi
  hostname
  libdatrie
  libepoxy
  libselinux
  libsepol
  libthai
  libxkbcommon
  pcre
  pcre2
  util-linux
  xorg.libXdmcp
  xorg.libXtst
]
