{ ... }:

{
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      adguard = {
        autoStart = true;
        image = "adguard/adguardhome";
        extraOptions = ["--dns=1.1.1.1"];
        ports = [
          "5353:53/tcp"
          "8080:80/tcp"
          "3000:3000/tcp"
        ];
        volumes = [
          "/var/lib/adguardhome/conf:/opt/adguardhome/conf"
          "/var/lib/adguardhome/work:/opt/adguardhome/work"
        ];
      };
    };
  };
}
