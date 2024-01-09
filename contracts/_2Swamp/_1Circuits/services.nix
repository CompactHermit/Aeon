{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption types;
  sys = config.modules.system;
  cfg = sys.services;

  /* *
     mkService:: String -> String|host -> Int -> Int -> {} -> f
  */
  mkService = { name, host ? "127.0.0.1", address ? 0, options ? { }, }: { };
in { }
