{ lib, ... }: {
  perSystem = { pkgs, ... }: {
    packages.zotero7 = pkgs.stdenv.mkDerivation rec {
      src = ./.;
      name = "Zotero";
      version = "7.0.0";
      nativeBuildInputs = with pkgs; [ wrapGAppsHook ];
      buildInputs = with pkgs; [
        gsettings-desktop-schemas
        glib
        gtk3
        gnome.adwaita-icon-theme
        dconf
      ];
      dontConfigure = true;
      dontBuild = true;
      dontStrip = true;
      dontPatchELF = true;
      libPath = lib.makeLibraryPath (with pkgs;
        [
          stdenv.cc.cc
          atk
          cairo
          curl
          cups
          dbus-glib
          dbus
          fontconfig
          #freetype
          gdk-pixbuf
          glib
          glibc
          gtk3
          libnotify
          alsa-lib
          libGLU
          libGL
          nspr
          nss
          pango
        ] ++ (with xorg; [
          libX11
          libXScrnSaver
          libXcomposite
          libXcursor
          libxcb
          libXdamage
          libXext
          libXfixes
          libXi
          libXtst.out
          libXinerama
          libXrender
          libXt
        ])) + ":"
        + lib.makeSearchPathOutput "lib" "lib64" [ pkgs.stdenv.cc.cc ];
      installPhase = # bash
        ''
          runHook preInstall

          echo $prefix
          mkdir -p "$prefix/usr/lib/zotero-bin-${version}"
          cp -r * "$prefix/usr/lib/zotero-bin-${version}"
          mkdir -p "$out/bin"
          ln -s "$prefix/usr/lib/zotero-bin-${version}/zotero" "$out/bin/"
          for executable in \
          zotero-bin plugin-container \
          updater minidump-analyzer
          do
          if [ -e "$out/usr/lib/zotero-bin-${version}/$executable" ]; then
          patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          "$out/usr/lib/zotero-bin-${version}/$executable"
          fi
          done
          find . -executable -type f -exec \
          patchelf --set-rpath "$libPath" \
          "$out/usr/lib/zotero-bin-${version}/{}" \;

          runHook postInstall
        '';

      preFixup = ''
        gappsWrapperArgs+=(--prefix PATH : ${
          lib.makeBinPath [ pkgs.coreutils ]
        })
      '';
    };
  };
}
