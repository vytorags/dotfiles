{ ... }:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ../../modules/profiles/desktop
  ];

  networking.hostName = "gh0stk";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";

      INTEL_GPU_MIN_FREQ_ON_AC = 350;
      INTEL_GPU_MAX_FREQ_ON_AC = 1050;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1050;

      SOUND_POWER_SAVE_ON_AC = 0;
      WIFI_PWR_ON_AC = "off";
    };
  };
}
