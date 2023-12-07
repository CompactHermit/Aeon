{
  description = "Aeon:: The timeless Flake";
  nixConfig = {
    extra-substituters = [
      "https://ezkea.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  outputs = inputs @ {
    self,
    parts,
    ...
  }:
    parts.lib.mkFlake {inherit inputs;} {
      debug = true;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = with inputs;
        [
          nixos-flake.flakeModule
          treefmt.flakeModule
          pch.flakeModule
          hci.flakeModule
        ]
        ++ [
          #./machines/Ragnarok #ISO, a bit broken RN but it's all g
          ./checks #PCH/TREEFMT
          ./users # Config Dir ++ Libs
          ./home #HM Garbage
          ./nixos #NixOS Modules
          #./scripts # MC / ISO flashing // TODO:: Use Justfiles with custom shellscripts, ya MONKEY!!
        ];

      flake = {
        lib = import ./contracts/default.nix {inherit (inputs.nixpkgs) lib;};
        nixosConfigurations = {
          # Work Machine
          Kepler = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              self.nixosModules.xmonad
              self.nixosModules.system
              ./machines/Genghis
            ];
          };

          # Home-Server
          Copernicus = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              ./machines/Caesar
            ];
          };

          # Android Phone::

          # WSL::
          Gryphon = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              self.nixosModules.xmonad
              self.nixosModules.wsl
            ];
          };
        };
        darwinConfigurations = {
          Alexander = self.nixos-flake.lib.mkMacosSystem {
            nixpkgs.hostPlatform = "aarch64-darwin";
            imports = [
              self.darwinModules.default # Defined in nix-darwin/default.nix
              ./machines/Alexander
            ];
          };
        };
      };

      perSystem = {
        self',
        pkgs,
        config,
        ...
      }: {
        packages = {
          default = self'.packages.activate;
        };
        devShells = {
          default = pkgs.mkShell {
            name = "Lazy ISO Flashing";
            inputsFrom = with config; [
              treefmt.build.devShell
              pre-commit.devShell
            ];
            packages = with pkgs; [just gum];
          };
        };
      };
    };

  inputs = {
    # @ System
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-wsl = {
      url = "github:viperML/home-manager-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
    };
    flake-registry = {
      url = "github:NixOS/flake-registry";
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
    nuenv.url = "github:DeterminateSystems/nuenv";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    #schizofox.url = "github:schizofox/schizofox";
    #nixci.url = "github:srid/nixci";
    attic = {
      url = "github:zhaofengli/attic";
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
    taffybar.url = "github:taffybar/taffybar";
    oxocarbon-gtk.url = "git+file:/home/CompactHermit/Dotfiles/oxocarbon-gtk";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";

    # @Android Development::
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs/canary";

    # @Emcas:: My Beloved
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom.url = "github:nix-community/nix-doom-emacs";

    # @Neovim::
    nyoom = {
      url = "github:CompactHermit/nyoom.nvim/nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
