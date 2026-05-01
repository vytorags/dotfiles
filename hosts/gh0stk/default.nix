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
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      INTEL_GPU_MIN_FREQ_ON_AC = 850;
      INTEL_GPU_MAX_FREQ_ON_AC = 1350;
      INTEL_GPU_BOOST_FREQ_ON_AC = 1350;

      SOUND_POWER_SAVE_ON_AC = 0;

      WIFI_PWR_ON_AC = "off";

      USB_AUTOSUSPEND = 0;
    };
  };
}
