{
  config,
  pkgs,
  lib,
  ...
}:
let
  font = config.stylix.fonts.monospace;
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "cyberpunk";
    themeConfig = with config.lib.stylix.colors.withHashtag; {
      Background = "${../../../assets/wallpapers/wallhaven_md5mj9.jpg}";
      Font = "${font.name}";
      HeaderTextColor = "${base0E}";
      DateTextColor = "${base08}";
      TimeTextColor = "${base0C}";
      FormBackgroundColor = "${base00}";
      BackgroundColor = "${base00}";
      DimBackgroundColor = "${base00}";
      LoginFieldBackgroundColor = "${base01}";
      PasswordFieldBackgroundColor = "${base01}";
      LoginFieldTextColor = "${base05}";
      PasswordFieldTextColor = "${base05}";
      UserIconColor = "${base0D}";
      PasswordIconColor = "${base0D}";
      PlaceholderTextColor = "${base03}";
      WarningColor = "${base09}";
      LoginButtonTextColor = "${base00}";
      LoginButtonBackgroundColor = "${base0B}";
      SystemButtonsIconsColor = "${base08}";
      SessionButtonTextColor = "${base08}";
      VirtualKeyboardButtonTextColor = "${base08}";
      DropdownTextColor = "${base05}";
      DropdownSelectedBackgroundColor = "${base0E}";
      DropdownBackgroundColor = "${base01}";
      HighlightTextColor = "${base00}";
      HighlightBackgroundColor = "${base0D}";
      HighlightBorderColor = "${base0D}";
      HoverUserIconColor = "${base0E}";
      HoverPasswordIconColor = "${base0E}";
      HoverSystemButtonsIconsColor = "${base0E}";
      HoverSessionButtonTextColor = "${base0E}";
      HoverVirtualKeyboardButtonTextColor = "${base0E}";
    };
  };
in
{
  services = {
    displayManager = {
      enable = true;
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "sddm-astronaut-theme";
        extraPackages = [ sddm-astronaut ];
      };
      defaultSession = "niri";
    };
  };

  environment.systemPackages = [ sddm-astronaut ];
}
