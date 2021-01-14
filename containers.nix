{ ... }:

{
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      adguard = {
        autoStart = true;
        image = "adguard/adguardhome";
        extraOptions = [ "--dns=1.1.1.1" "--dns=8.8.8.8" ];
        ports = [ "53:53/tcp" "53:53/udp" "8080:80/tcp" ];
        volumes = [
          "/var/lib/adguardhome/conf:/opt/adguardhome/conf"
          "/var/lib/adguardhome/work:/opt/adguardhome/work"
        ];
      };
    };
  };
}
