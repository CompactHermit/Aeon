{ lib, ... }:
{
  modules = import ./modules.nix { inherit lib; };
  dag = import ./dag.nix { inherit lib; };
  systems = import ./system.nix { inherit lib; };
}
