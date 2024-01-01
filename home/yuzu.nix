{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.yuzu-mainline];
}
