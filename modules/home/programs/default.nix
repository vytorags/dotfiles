{
  lib,
  role ? "desktop",
  isDesktop,
  ...
}:
{
  imports = [
    ./niri
    ./stylix
    ./noctalia
    ./wezterm
    ./direnv
    ./yazi
    ./btop
    ./shell
    # ./starship
    ./sioyek
  ]
  ++ lib.optionals isDesktop [
    ./fastfetch
    ./cava
    ./lazygit
    ./vesktop
  ];
}
