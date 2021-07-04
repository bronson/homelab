{ ... }:

{
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      # adguard = {
      #   autoStart = true;
      #   image = "adguard/adguardhome";
      #   extraOptions = [ "--dns=1.1.1.1" "--dns=8.8.8.8" ];
      #   ports = [ "53:53/tcp" "53:53/udp" "8080:80/tcp" ];
      #   volumes = [
      #     "/var/lib/adguardhome/conf:/opt/adguardhome/conf"
      #     "/var/lib/adguardhome/work:/opt/adguardhome/work"
      #   ];
      # };

      # grafana = {
      #   autoStart = true;
      #   image = "grafana/grafana:7.3.6";
      #   ports = [ "3000:3000" ];
      #   volumes = [ "/var/lib/grafana:/var/lib/grafana" ];
      # };

      paperless-redis = {
        autoStart = true;
        image = "redis:6.0";
      };

      paperless-webserver = {
        autoStart = true;
        image = "jonaswinkler/paperless-ng:latest";
        ports = [ "8000:8000/tcp" ];
        environment = {
          PAPERLESS_TIME_ZONE = "America/Vancouver";
          PAPERLESS_REDIS = "redis://paperless-redis:6379";
          PAPERLESS_TIKA_ENABLED = "1";
          PAPERLESS_TIKA_ENDPOINT = "http://tika:9998";
          PAPERLESS_TIKA_GOTENBERG_ENDPOINT = "http://gotenberg:3000";
        };
        volumes = [
          "/var/lib/paperless/consume:/usr/src/paperless/consume"
          "/var/lib/paperless/data:/usr/src/paperless/data"
          "/var/lib/paperless/export:/usr/src/paperless/export"
          "/var/lib/paperless/media:/usr/src/paperless/media"
        ];
      };

      gotenberg = {
        autoStart = true;
        image = "thecodingmachine/gotenberg";
        environment = {
          DISABLE_GOOGLE_CHROME = "1";
        };
      };

      tika = {
        autoStart = true;
        image = "apache/tika";
      };
    };
  };
}
