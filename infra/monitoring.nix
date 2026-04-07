{ config, pkgs, lib, ... }: {
  services.prometheus = {
    enable = true;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [{ targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ]; }];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings.server = {
      http_addr = "127.0.0.1";
      http_port = 3000;
      domain = "localhost";
    };
  };

  systemd.services.prometheus.serviceConfig.Restart = lib.mkForce "always";
  systemd.services.grafana.serviceConfig.Restart = lib.mkForce "always";
}
