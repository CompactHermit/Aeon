{pkgs ,lib ,config ,...}:{
  environment = {
    sessionVariables = {
      PAGER = "less";
      LESS = "-iFJMRWX -z-4 -x4";
      LESSOPEN = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      binutils
      coreutils
      curl
      dnsutils
      dosfstools
      encfs
      fd
      git

      gptfdisk
      iputils
      jq
      manix
      moreutils
      lsof
      nix-index
      nmap
      openssl
      pwgen
      ripgrep
      skim
      tealdeer
      screen
      inetutils
      utillinux
      whois
      xdg-utils

      bat
      gzip
      lrzip
      p7zip
      procs
      skim
      unrar
      unzip

      iproute2
      protonvpn-cli_2

      appimage-run
      cntr
      adoptopenjdk-icedtea-web

      #libbitcoin-explorer
      wf-recorder
      boost175
      bottom
      clang
      cmake
      encfs
      file

      parted
      gcc
      git-filter-repo
      gnumake
      gnupg
      gpgme

      #go
      gopls
      #gopass
      go-2fa
      imagemagick
      less
      ncdu
      neofetch

      #Nix-related
      nix-serve
      nixpkgs-review
      nil

      nodejs
      yarn
      libusb1

      texlive.combined.scheme-full
      pandoc
      #orgtoinvoice
      sshfs
      pkg-config
      rubber
      sqlite
      tig
      tokei
      tree
      viu
      wget
      youtube-dl
      #lmms
      #fluidsynth
      #audacity
      obs-studio
      #platformio
      #obs-wlrobs
    ];
    shellAliases =
      let ifSudo = lib.mkIf config.security.sudo.enable;
      in
      {
        # quick cd
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        # git
        g = "git";

        # grep
        grep = "rg";
        gi = "grep -i";

        # internet ip
        myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";

        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';

        # top
        top = "btm";

        # systemd
        ctl = "systemctl";
        stl = ifSudo "s systemctl";
        utl = "systemctl --user";
        ut = "systemctl --user start";
        un = "systemctl --user stop";
        up = ifSudo "s systemctl start";
        dn = ifSudo "s systemctl stop";
        jtl = "journalctl";

      };
  };
}
