{

  # TODO:: (CH) Add my cachix, once we get hydra running.
  # The More, the merrier. We're not Gentoo, amiright?
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://fortuneteller2k.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://viperml.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
    ];
  };
  inputs = {
    # All the basic inputs
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

    #TOOLING
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nuenv.url = "github:DeterminateSystems/nuenv";
    ragenix.url = "github:yaxitech/ragenix";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hydra.url = "github:NixOS/hydra";
    nixci.url = "github:srid/nixci";

    #Media::
    schizofox.url = "github:schizofox/schizofox";

    # Flake-Parts Modules
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

    # Emacs
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

    # NOTE:: (Hermit) Overlay Borked itself
    #Neovim
    # nyoom = {
    #   url = "github:CompactHermit/nyoom.nvim/nightly";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
  outputs = inputs@{ self,parts, ... }:
  parts.lib.mkFlake { inherit inputs; } {
    debug = true;

    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    imports = with inputs;[
      nixos-flake.flakeModule
        treefmt.flakeModule
        pch.flakeModule
      ] ++ [
        ./checks
        ./users
        ./home
        ./nixos
      ];

    flake = {
      nixosConfigurations = {
          # Work Machine
          Kepler = self.nixos-flake.lib.mkLinuxSystem {
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              self.nixosModules.default
              ./machines/Genghis
            ];
          };

          # ISO:: Basic Rooting
          # Copernicus  = self.nixos-flake.lib.mkLinuxSystem {
          #   nixpkgs.hostPlatform = "x86_64-linux";
          #   imports = [
          #     ./machines/Ragnarok
          #   ];
          # };
          #
          # # Server Slave:: Intel i3-7100u
          # Shyama = self.nixos-flake.lib.mkLinuxSystem {
          #   nixpkgs.hostPlatform = "x86_64-linux";
          #   imports = [
          #     ./machines/Caesar
          #   ];
          # };
        };

      #
      # darwinConfigurations = {
      #   Alexander = self.nixos-flake.lib.mkMacosSystem {
      #     nixpkgs.hostPlatform = "aarch64-darwin";
      #     imports = [
      #       self.darwinModules.default # Defined in nix-darwin/default.nix
      #       ./machines/Alexander
      #     ];
      #   };
      # };
    };
    perSystem = { self', system, pkgs, lib, config, inputs',...}:{
      packages = {
        default = self'.packages.activate;
      };
    };
    };
  }
