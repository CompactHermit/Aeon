{ ... }: {
  myself = "CompactHermit";
  users = {
    CompactHermit = {
      name = "Compact Hermitian";
      email = "compacthermit@proton.me";
      sshKeys = [
        # TODO:: Use sops for keyfiles
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMY0THlPPTjhzyzBDwJwtTawYoauGFoxWmf7myf6qWZ"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcT4qbDw9oca44wv1qXdmaskU5jhCAgSs6PyVV19eKp"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhwcctNXxllJiC9oK1HKLVpGS2i8YIvlBmP9FpsyeoE"
      ];
    };
  };
}
