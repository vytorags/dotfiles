{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.drivers.intel;
in
{
  options.drivers.intel = {
    enable = mkEnableOption "Enable Intel Graphics Drivers";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "intel" ];
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        intel-vaapi-driver
        mesa
        libglvnd
        vulkan-loader
        libva
      ];
    };

    environment.variables = {
      LIBVA_DRIVER_NAME = "i965";
      VDPAU_DRIVER = "va_gl";
    };
  };
}
