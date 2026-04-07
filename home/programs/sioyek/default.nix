{ config, ... }:
{
  programs.sioyek = {
    enable = true;

    config = with config.lib.stylix.colors; {
      "background_color" = "#${base00}";
      "dark_mode_background_color" = "#${base00}";
    };
  };
}
