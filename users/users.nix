{lib, ...}: let
  userSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
      };
      email = lib.mkOption {
        type = lib.types.str;
      };
      sshKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          SSH public keys
        '';
      };
    };
  };
in {
  options = {
    people = lib.mkOption {
      type = lib.types.submodule {
        options = {
          users = lib.mkOption {
            type = lib.types.attrsOf userSubmodule;
            description = ''
              The name of the use, their email/domain,
              and Trusted SSH-keys
            '';
          };
          myself = lib.mkOption {
            type = lib.types.str;
            description = ''
              The name of the user that represents myself.
              Admin user in all contexts.
            '';
          };
        };
      };
    };
  };
  config = {
    people = import ./config.nix;
  };
}
