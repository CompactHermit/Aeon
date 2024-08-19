{ ... }:
{
  services.hydra = {
    enable = true;
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    hydraURL = "http://localhost:3000"; # externally visible URL
    #buildMachinesFiles = [ "/etc/nix/hydra-machines" ];
    useSubstitutes = true;
  };
}
