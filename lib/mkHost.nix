# Helper function to create a NixOS host configuration
# This encapsulates the common host creation logic
{
  nixpkgs,
  home-manager,
  inputs,
  nur,
  sharedHomeManager,
  unstable,
  pkgs,
}:
name:
let
  metaPath = ../hosts/${name}/meta.nix;
  meta = if builtins.pathExists metaPath then import metaPath else { };
  role = meta.role or "desktop";
  isDesktop = meta.isDesktop or (role == "desktop");
  hostName = meta.hostName or name;
  system = "x86_64-linux";
in
nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit
      inputs
      unstable
      role
      isDesktop
      hostName
      ;
  };
  modules = [
    ../hosts/${name}
    nur.modules.nixos.default
    inputs.stylix.nixosModules.stylix
    {
      stylix = {
        polarity = "dark";
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

        fonts = {
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
    }
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.mangowm.nixosModules.mango
    home-manager.nixosModules.home-manager
    (sharedHomeManager {
      inherit role hostName isDesktop;
    })
  ];
}
