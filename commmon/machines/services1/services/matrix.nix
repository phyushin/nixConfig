{
  pkgs,
  lib,
  config,
  ...
}:
let
  CONFIG = import ../config.nix;
  fqdn = "matrix.phyubox.com";
  baseUrl = "https://matrix.phyubox.com";
  clientConfig."m.homeserver".base_url = baseUrl;
  serverConfig."m.server" = "matrix.phyubox.com:443";
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  # Necessary for secret access
  users.groups.secrets.members = [
    "synapse"
    "matrix-synapse"
  ];

  services.nginx = {
    virtualHosts = {
      "matrix.phyubox.com" = {
        useACMEHost = "phyubox.com";
        forceSSL = true;

        # It's also possible to do a redirect here or something else, this vhost is not
        # needed for Matrix. It's recommended though to *not put* element
        # here, see also the section about Element.
        locations."/" = {
          extraConfig = ''
            return 404;
          '';
        };

        # Forward all Matrix API calls to the synapse Matrix homeserver. A trailing slash
        # *must not* be used here.
        locations."/_matrix" = {
          proxyPass = "http://[::1]:8008";
          recommendedProxySettings = true;
        };

        # Forward requests for e.g. SSO and password-resets.
        locations."/_synapse/client" = {
          proxyPass = "http://[::1]:8008";
          recommendedProxySettings = true;
        };

        locations."/_synapse/admin" = {
          proxyPass = "http://[::1]:8008";
          recommendedProxySettings = true;
        };
      };

      "element.phyubox.com" = {
        useACMEHost = "phyubox.com";
        forceSSL = true;

        root = pkgs.element-web.override {
          conf = {
            default_server_config = clientConfig; # see `clientConfig` from the snippet above.

            "sso_redirect_options" = {
              "immediate" = false;
              "on_welcome_page" = true;
              "on_login_page" = true;
            };

            "oidc_static_clients" = {
              "https://${CONFIG.AUTHENTIK_DOMAIN}/" = {
                "client_id" = "MPrS3RN7iTktF9bjWTtZkKDJFZsAyz5yTFv8NpvG";
              };
            };
          };
        };
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "matrix.phyubox.com";
      public_baseurl = baseUrl;

      login_via_existing_session = {
        enabled = true;
        require_ui_auth = false;
        token_timeout = "5m";
      };

      listeners = [
        {
          port = 8008;
          bind_addresses = [ "::1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = true;
            }
          ];
        }
      ];
    };
    extras = [ "oidc" ];
    extraConfigFiles = [ "/var/lib/secrets/synapse-authentik.yaml" ];
  };

  # # Didn't work, run manually...
  # system.activationScripts.createMatrixDatabase = ''
  #   CREATE ROLE "matrix-synapse";
  #   CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
  #     TEMPLATE template0
  #     LC_COLLATE = "C"
  #     LC_CTYPE = "C";
  # '';
}

## Make a Authentik signed in user as admin...
# sudo -u postgres psql matrix-synapse
# UPDATE users SET admin = 1 WHERE name = '@cjdell:matrix.leighhack.org';