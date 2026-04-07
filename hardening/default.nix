{ ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    trustedInterfaces = [
      "lo"
      "tailscale0"
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
  };

  services.fail2ban.enable = true;

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };
}
