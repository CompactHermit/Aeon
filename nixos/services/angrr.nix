{ pkgs, ... }:
{
  services.angrr = {
    enable = true;
    period = "2weeks";
  };
  environment.systemPackages = builtins.attrValues { inherit (pkgs) angrr; };
}
