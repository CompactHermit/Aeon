{ config, flake, ... }:
let
  people = flake.config.people;
  myKeys = people.users.${people.myself}.sshKeys;
in {
  # Let me login
  users.users = {
    root.openssh.authorizedKeys.keys = myKeys;
    ${people.myself} = { openssh.authorizedKeys.keys = myKeys; };
    ${config.services.gitea.user} = {
      openssh.authorizedKeys.keys = [ (builtins.elemAt myKeys 2) ];
      extraGroups = [ "postgres" ];
    };
    ${config.services.nginx.user}.extraGroups = [ config.services.gitea.group ];
  };
}
