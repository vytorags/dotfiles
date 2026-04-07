{
  config,
  pkgs,
  isDesktop,
  ...
}:
let
  font = config.stylix.fonts.monospace;
in
{
  stylix = {
    enable = true;
    polarity = "dark";

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";

    base16Scheme = {
      base00 = "#1d2021";
      base01 = "#282828";
      base02 = "#3c3836";
      base03 = "#504945";
      base04 = "#bdae93";
      base05 = "#d5c4a1";
      base06 = "#ebdbb2";
      base07 = "#fbf1c7";
      base08 = "#d43847";
      base09 = "#b82c3b";
      base0A = "#e55f4f";
      base0B = "#c32d3a";
      base0C = "#dd434e";
      base0D = "#9f2231";
      base0E = "#c72f44";
      base0F = "#7c1a27";
    };

    # base16Scheme = {
    #   base00 = "282828";
    #   base01 = "32302f";
    #   base02 = "45403d";
    #   base03 = "5a524c";
    #   base04 = "a89984";
    #   base05 = "ddc7a1";
    #   base06 = "ebdbb2";
    #   base07 = "fbf1c7";
    #   base08 = "e96962";
    #   base09 = "e68a4e";
    #   base0A = "d7a657";
    #   base0B = "a8b665";
    #   base0C = "89b482";
    #   base0D = "7daea3";
    #   base0E = "d3869b";
    #   base0F = "555c34";
    # };

    targets = {
      gtk.enable = true;
      gtk.flatpakSupport.enable = isDesktop;
      qt.enable = true;
      vscode.enable = false;
      cava.enable = false;
      noctalia-shell.enable = false;
      starship.enable = false;
      dank-material-shell.enable = false;
    };

    fonts = {
      serif = font;
      sansSerif = font;
      emoji = font;
      monospace = {
        name = "VictorMono Nerd Font";
      };
    };

    cursor = {
      name = "Vimix-cursors";
      package = pkgs.vimix-cursors;
      size = 32;
    };
  };

  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     color-scheme = "prefer-dark";
  #   };
  # };
  #
  # xdg.configFile."gtk-3.0/settings.ini".text = ''
  #   gtk-application-prefer-dark-theme=true
  # '';
  #
  # xdg.configFile."gtk-4.0/settings.ini".text = ''
  #   gtk-application-prefer-dark-theme=true
  # '';
}
