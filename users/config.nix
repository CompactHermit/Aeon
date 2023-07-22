{...}:{
  myself = "CompactHermit";
  users = {
    CompactHermit = {
      name = "Compact Hermitian";
      email = "compacthermit@proton.me";
      sshKeys = [

        # Gitlabs
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMY0THlPPTjhzyzBDwJwtTawYoauGFoxWmf7myf6qWZ compacthermit@gitlab"

        # Personal
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcT4qbDw9oca44wv1qXdmaskU5jhCAgSs6PyVV19eKp compacthermitian@proton.me"
      ];
    };
  };
}
