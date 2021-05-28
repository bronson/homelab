{ config, lib, pkgs, modulesPath, ... }:

let
  # Scrape a list of static targets for a job.
  staticScrape = (job_name: targets: {
    inherit job_name;
    static_configs = [{ inherit targets; }];
  });

in {
  # Prometheus monitoring server and exporter configuration.
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "15s";

    extraFlags = [ "--storage.tsdb.retention=180d" "--web.enable-admin-api" ];

    scrapeConfigs = [ (staticScrape "node" [ "0.0.0.0:9100" ]) ];
  };
}
