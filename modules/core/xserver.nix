{ pkgs, ... }:
{
  services.xserver = {
    enable = true;

    xkb = {
      layout = "br";
      variant = "";
    };

    excludePackages = [ pkgs.xterm ];

    deviceSection = ''
      Option "AccelMethod" "none"
    '';
  };
}
