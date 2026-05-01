{
  pkgs,
  config,
  inputs,
  unstable,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  font = config.stylix.fonts.monospace;

in
{
  imports = [
    ./dms.nix
  ];

  programs.noctalia-shell = with config.lib.stylix.colors.withHashtag; {
    enable = true;

    colors = {
      mError = "${base08}";
      mHover = "${base0C}";
      mOnError = "${base00}";
      mOnPrimary = "${base00}";
      mOnSecondary = "${base00}";
      mOnSurface = "${base05}";
      mOnSurfaceVariant = "${base04}";
      mOnTertiary = "${base0C}";
      mOutline = "${base02}";
      mPrimary = "${base0E}";
      mSecondary = "${base0A}";
      mShadow = "${base00}";
      mSurface = "${base00}";
      mSurfaceVariant = "${base01}";
      mTertiary = "${base0D}";
    };

    # plugins = {
    #   sources = [
    #     {
    #       enabled = true;
    #       name = "Noctalia Plugins";
    #       url = "https://github.com/noctalia-dev/noctalia-plugins";
    #     }
    #   ];
    #   states = {
    #     assistant-panel = {
    #       enabled = true;
    #       sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
    #     };
    #     calibre-provider = {
    #       enabled = true;
    #       sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
    #     };
    #     pomodoro = {
    #       enabled = true;
    #       sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
    #     };
    #     screen-recorder = {
    #       enabled = true;
    #       sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
    #     };
    #     todo = {
    #       enabled = true;
    #       sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
    #     };
    #   };
    #   version = 2;
    # };
  };
}
