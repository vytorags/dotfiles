{
  config,
  pkgs,
  lib,
  role ? "desktop",
  ...
}:
{
  imports = [
    ./packages.nix
    ./core
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  nix.settings = {
    substituters = [
      "https://viitorags.cachix.org"
    ];

    trusted-public-keys = [
      "viitorags.cachix.org-1:XjszObjD+IWSHIB37cprlJogQkkKgWLtcBRH7pi/gpE="
    ];

    fallback = false;
  };

  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
      {
        from = 24800;
        to = 24800;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "1.1.1.2"
    "8.8.8.8"
  ];

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  console.keyMap = "br-abnt2";

  nixpkgs.config.allowUnfree = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      epson-escpr
    ];
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="kyber"
    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="*::scrolllock", RUN+="/bin/sh -c 'chmod 666 /sys/class/leds/%k/brightness /sys/class/leds/%k/trigger'"
  '';

  system.stateVersion = "25.11";
}
