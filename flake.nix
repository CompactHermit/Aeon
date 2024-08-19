{
  description = "Aeon:: The timeless Flake";
  outputs =
    inputs@{ self, parts, ... }:
    parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      herculesCI.ciSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      imports =
        [
          inputs.nixos-unified.flakeModule
          inputs.treefmt.flakeModule
          inputs.pch.flakeModule
          inputs.hci.flakeModule
        ]
        ++ [
          ./checks # PCH/TREEFMT
          ./users # Config Dir ++ Libs
          ./home # HM Garbage
          ./nixos # NixOS Modules
          ./machines/_5Ragnarok # ISO, a bit broken RN but it's all g
          ./scripts/flash.nix
        ];
      flake = {
        contracts = import ./contracts {
          inherit (inputs.nixpkgs) lib;
          inherit self;
        };
        # TODO:: Module this away
        nixosConfigurations = {
          # Work Machine
          Kepler = self.nixos-unified.lib.mkLinuxSystem { home-manager = true; } ./machines/_3Genghis;

          # Home-Server
          Copernicus = self.nixos-unified.lib.mkLinuxSystem {
            home-manager = true;
          } ./machines/_6Siegfried;

          # PinePhonePro::
          Dirac = self.nixos-unified.lib.mkLinuxSystem {
            home-manager = true;
          } ./machines/_2Caesar;

          #Pocket-4
          Wyze = self.nixos-unified.lib.mkLinuxSystem {
            home-manager = true;
          } ./machines/_4Gilgamesh;
          # WSL::
          Schrodinger = self.nixos-unified.lib.mkLinuxSystem { } ./machines/_7Tell;
        };
        darwinConfigurations = {
          Nikola = self.nixos-unified.lib.mkMacosSystem { home-manager = true; } ./machines/Alexander;
        };
      };

      perSystem =
        {
          self',
          pkgs,
          config,
          ...
        }:
        {
          devShells = {
            default = pkgs.mkShell {
              name = "Lazy ISO Flashing";
              inputsFrom = with config; [
                treefmt.build.devShell
                pre-commit.devShell
              ];
              packages = builtins.attrValues {
                inherit (self'.packages)
                  Solomon_search
                  Ragnarok_Install
                  ;
                inherit (pkgs)
                  just
                  ;
              };
            };
          };
        };
    };
  # nixConfig = {
  #   extra-substituters = [ "https://cache.compacthermit.dev" ];
  #   extra-trusted-public-keys =
  #     [ "cache-cache.compacthermit.dev-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMASBepcDSHjY=" ];
  # };
  inputs = {
    # @ System
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #hotfix for ollama

    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-stable.url = "github:nixos/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #TODO:: Refactor this into seperate LIB::
    firefoxAddons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # impermanence.url = "github:nix-community/impermanence";
    preservation.url = "github:WilliButz/preservation";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
    };
    # dwarffs.url = "https://github.com/edolstra/dwarffs";
    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };
    flakey-profile.url = "github:lf-/flakey-profile";

    #for Pinephonepro Keyboard firmware
    mobile-nixos = {
      url = "github:NixOS/mobile-nixos/development";
      flake = false;
    };
    ppkb-fix = {
      url = "git+https://codeberg.org/aLilyBit/ppkb-layouts";
      flake = false;
    };

    # @ FP-modules
    parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";
    pch = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixfmt-rfc.url = "github:NixOS/nixfmt";

    hci = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs.flake-parts.follows = "parts";
    };

    # @Tooling
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty.url = "github:ghostty-org/ghostty";
    zellij = {
      url = "github:a-kenji/zellij-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad.url = "github:kmonad/kmonad/master?dir=nix";
    firefox-nightly.url = "github:mozilla/nixpkgs-mozilla";
    conduit.url = "gitlab:famedly/conduit?ref=next";
    angrr.url = "github:linyinfeng/angrr";
    nix-monitored.url = "github:ners/nix-monitored";
    tailscale-nameserver = {
      url = "github:boinkor-net/tsnsrv";
      inputs.parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # @Ricing/Gaming::
    jj.url = "github:jj-vcs/jj";
    niri.url = "github:sodiboo/niri-flake";
    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    picom.url = "github:FT-Labs/picom";
    taffybar.url = "github:taffybar/taffybar";
    #oxocarbon-gtk.url = "git+ssh://git@github:CompactHermit/oxocabon-gtk/master";
    tmux-which-key.url = "github:higherorderfunctor/tmux-which-key/feat/adds-nix-flake";
    nix-colors.url = "github:misterio77/nix-colors";
    stylix.url = "github:danth/stylix";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # @Android Development::
    #android-nixpkgs.url = "github:tadfisher/android-nixpkgs/canary";
    # hotfixes::
    # @Nightly Sources:: <TODO> :: To -> NvFetcher
    carapace = {
      url = "github:carapace-sh/carapace-bin/";
      flake = false;
    };
  };
}
