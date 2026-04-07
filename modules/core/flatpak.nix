{ pkgs, ... }:
{
  services.flatpak = {
    enable = true;
    packages = [
      # {
      #   appId = "com.usebottles.bottles";
      #   origin = "flathub";
      # }
      {
        appId = "org.vinegarhq.Sober";
        origin = "flathub";
      }
    ];
  };
}
