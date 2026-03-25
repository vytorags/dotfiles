{ ... }:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ../../modules/system/profiles/homelab.nix
  ];

  networking.hostName = "slime";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  services.xserver.xkb.options = "scrolllock:none";

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "ondemand";

      CPU_MAX_PERF_ON_AC = 100;
      CPU_BOOST_ON_AC = 1;

      INTEL_GPU_MIN_FREQ_ON_AC = 350;
      INTEL_GPU_MAX_FREQ_ON_AC = 650;
    };
  };
}
