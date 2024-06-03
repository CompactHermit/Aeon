{
  description = "Aeon:: The timeless Flake";
  outputs = inputs@{ self, parts, ... }:
    parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      herculesCI.ciSystems = [ "x86_64-linux" "aarch64-linux" ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      imports = with inputs;
        [
          nixos-flake.flakeModule
          treefmt.flakeModule
          pch.flakeModule
          hci.flakeModule
        ] ++ [
          ./checks # PCH/TREEFMT
          ./users # Config Dir ++ Libs
          ./home # HM Garbage
          ./nixos # NixOS Modules
          # ./parts/scripts # MC / ISO flashing // TODO:: Use Justfiles with custom shellscripts, ya MONKEY!!
          #./machines/Ragnarok #ISO, a bit broken RN but it's all g
        ];
      flake = {
        contracts = import ./contracts {
          inherit (inputs.nixpkgs) lib;
          inherit self;
        };
        nixosConfigurations = {
          # Work Machine
          Kepler = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              ./machines/_3Genghis
              self.nixosModules.xmonad
              self.nixosModules.system
            ];
          };

          # Home-Server
          Copernicus = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [ ./machines/_6Siegfried ];
          };

          # PinePhonePro::
          Dirac = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [ ./machines/_2Caesar self.nixosModules.mobile ];
          };

          # WSL::
          Schrodinger = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [ ./machines/_7Tell self.nixosModules.wsl ];
          };
        };
        darwinConfigurations = {
          Nikola = self.nixos-flake.lib.mkMacosSystem {
            nixpkgs.hostPlatform = "aarch64-darwin";
            imports = [
              self.darwinModules.default # Defined in nix-darwin/default.nix
              ./machines/Alexander
            ];
          };
        };
      };

      perSystem = { self', pkgs, config, ... }: {
        packages = { default = self'.packages.activate; };
        devShells = {
          default = pkgs.mkShell {
            name = "Lazy ISO Flashing";
            inputsFrom = with config; [
              treefmt.build.devShell
              pre-commit.devShell
            ];
            packages = with pkgs; [ just gum nixfmt ];
          };
        };
      };
    };
  nixConfig = {
    extra-substituters = [ "https://ezkea.cachix.org" ];
    extra-trusted-public-keys =
      [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
  };
  inputs = {
    # @ System
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
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
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = { url = "github:nix-community/lanzaboote/v0.3.0"; };
    # dwarffs.url = "https://github.com/edolstra/dwarffs";
    flake-registry = {
      url = "github:NixOS/flake-registry";
      flake = false;
    };
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
    nixos-flake.url = "github:srid/nixos-flake";
    pch = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    # For headscale ui
    nyxpkgs.url = "github:notashelf/nyxpkgs";
    attic = {
      url = "github:zhaofengli/attic";
      #url = "github:JRMurr/attic/fix-lint"; # temporary
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zellij = {
      url = "github:a-kenji/zellij-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad.url = "github:kmonad/kmonad/master?dir=nix";
    firefox-nightly.url = "github:mozilla/nixpkgs-mozilla";
    conduit.url = "gitlab:famedly/conduit?ref=next";
    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # @Ricing/Gaming::
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
    oxocarbon-gtk.url = "git+file:/home/CompactHermit/Dotfiles/oxocarbon-gtk";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";

    # @Android Development::
    #android-nixpkgs.url = "github:tadfisher/android-nixpkgs/canary";

    # @Nightly Sources::
    carapace = {
      url = "github:carapace-sh/carapace-bin/";
      flake = false;
    };
  };
}
