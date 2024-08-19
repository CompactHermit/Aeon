{ config, ... }:
{
  # services.tailscale.enable = true;
  # networking.firewall = {
  #   checkReversePath = "loose";
  #   trustedInterfaces = [ "tailscale0" ];
  #   allowedUDPPorts = [ config.services.tailscale.port ];
  # };
  #TODO:: (hermit) Create custom Module for adding tailscale stuff, specifically systemd
}
