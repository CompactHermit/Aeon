{...}: let
  # Don't Know why this isn't inherited, weird af
  excludes = ["flake.lock" "r'.+\.age$'" "r'.+\.sh$'"];

  # MkHook:: (String) -> (Attrs::{enable ? bool}) -> (Attrs::PCH)
  mkHook = name: prev:
    {
      inherit excludes;
      description = "pre-commit hook for ${name}";
      fail_fast = true;
      verbose = true;
    }
    // prev;
in {
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    pre-commit = {
      check.enable = true;

      settings = {
        inherit excludes;
        hooks = {
          #TODO:: (Hermit) Add cabal linter
          actionlint = mkHook "actionlint" {enable = true;};
          treefmt = mkHook "treefmt" {enable = true;};
          prettier = mkHook "prettier" {enable = true;};
          editorconfig-checker = mkHook "editorconfig" {
            enable = false;
            always_run = true;
          };
        };
        # NOTE:: (Hemrit) Numtide Unoficcially said they were on drugs when they made this
        # (Hermit) This Looks so fucking stupid, settings.<settings>.?
        settings = {
          treefmt = {
            package = config.treefmt.build.wrapper;
          };
        };
      };
    };
  };
}
