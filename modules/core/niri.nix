{
  pkgs,
  inputs,
  ...
}:
{
  programs.niri = {
    enable = true;
    package = inputs.niri-blur.packages.${pkgs.system}.niri;
  };
}
