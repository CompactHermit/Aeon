{ lib, pkgs, config, ... }: {
  /* *
     Module:: DDNS
       DuckDNS to handle all dynamic IP's
  */
  sops.secrets.clf_API = { };

  systemd.services.ddns = {
    reloadIfChanged = false;
    restartIfChanged = false;
    stopIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    startAt = "*:0/30";

    serviceConfig = {
      EnvironmentFile = config.sops.secrets.cloudflare.path;
      DynamicUser = true;
    };

    path = [ pkgs.netcat pkgs.jq pkgs.curl ];

    script =
      # bash
      ''
        if ! nc -zw1 google.com 443 &>/dev/null; then
        echo No Internet access... bailing early
        exit 0
        fi

        IP=$(grep -oP '^((?!fe80).).{22}ffee.{5}' /proc/net/if_inet6 | sed -E 's/(.{4})/\1:/g; s/.$//')

        func () {
          RECORD="$1"
          ZONE="$2"
          PROXY="''${3:-"true"}"


          REQ=$(curl --silent \
          --request GET \
          --url "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records" \
          --header 'Content-Type: application/json' \
          --header "Authorization: Bearer $AUTH"
          )

          readarray -t AR < <(jq -r '.result[].name' <<< "$REQ")

          for i in "''${!AR[@]}"; do
          if [ "''${AR[i]}" == "$RECORD" ]; then
          ID=$(jq -r ".result[$i].id" <<< "$REQ")
          if [ "$(jq -r ".result[$i].content" <<< "$REQ")" == "$IP" ]; then
          echo "IP was the same, returing early"
          return 0
          fi
          break
          fi
          done


          curl --silent \
          --request PATCH \
          --url "https://api.cloudflare.com/client/v4/zones/$ZONE/dns_records/$ID" \
          --header "Authorization: Bearer $AUTH" \
          --header "Content-Type: application/json" \
          --data '{
            "content": "'"$IP"'",
            "name": "'"$RECORD"'",
            "proxied": '"$PROXY"',
            "type": "AAAA",
            "comment": "",
            "tags": [],
            "ttl":  1
          }'
        }

        func "*.compacthermit.dev" "9bf9d244-8408-44c1-ac81-409dc35c24f1"
      '';
  };
}
