{
  config,
  pkgs,
  unstable,
  lib,
  role ? "desktop",
  isDesktop,
  vars,
  ...
}:
let
  homeDir = config.home.homeDirectory;
in
{
  imports = [
    ./programs
  ];

  home = {
    username = vars.username;
    homeDirectory = lib.mkForce "/home/${vars.username}";
    stateVersion = "25.05";
    packages = with pkgs; [
      bc
      usbutils
      usbredir
    ];

    sessionVariables = {
      TERMINAL = "wezterm";
      EDITOR = "nvim";
    };

    file.".face".source = ../assets/profile.png;
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  nix.registry = {
    dev = {
      from = {
        id = "dev";
        type = "indirect";
      };
      to = {
        type = "path";
        path = "${config.home.homeDirectory}/nixdots";
      };
    };
  };
}
