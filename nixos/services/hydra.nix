{ ... }: {
  services.hydra = {
    enable = true;
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    hydraURL = "http://localhost:3000"; # externally visible URL
    #buildMachinesFiles = [ "/etc/nix/hydra-machines" ];
    useSubstitutes = true;
    # extraEnv = {
    #   AWS_SHARED_CREDENTIALS_FILE = config.age.secrets.hydraS3.path;
    #   PGPASSFILE =
    #     config.age.secrets."hydra-database-credentials-for-hydra".path;
    # };
  };
}
