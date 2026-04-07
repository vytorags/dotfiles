{
  description = "Viitorags NixOs Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    mynvim.url = "github:viitorags/nvim";

    stylix.url = "github:nix-community/stylix";

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

    niri-blur.url = "github:YaLTeR/niri?ref=wip/branch";

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    inir = {
      url = "github:vytaro/iNir";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      mynvim,
      noctalia,
      nur,
      agenix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      vars = import ./vars;

      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      getDev =
        role: isDesktop:
        import ./dev {
          inherit
            pkgs
            unstable
            mynvim
            role
            isDesktop
            ;
        };

      sharedHomeManager =
        {
          role,
          hostName,
          isDesktop,
        }:
        let
          dev = import ./dev {
            inherit
              pkgs
              unstable
              mynvim
              role
              isDesktop
              ;
          };

          hostHome = ./hosts/${hostName}/home.nix;
        in
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit
              inputs
              unstable
              mynvim
              noctalia
              role
              isDesktop
              hostName
              vars
              ;
          };
          home-manager.users.${vars.username} = {
            imports = [
              ./home/home.nix
            ]
            ++ lib.optional (builtins.pathExists ./home/profiles/${role}.nix) ./home/profiles/${role}.nix
            ++ lib.optional (builtins.pathExists ./home/profiles/${role}-packages.nix) ./home/profiles/${role}-packages.nix
            ++ [
              inputs.niri-flake.homeModules.niri
              inputs.stylix.homeModules.stylix
              noctalia.homeModules.default
              inputs.dms.homeModules.dank-material-shell
              inputs.mangowm.hmModules.mango
            ]
            ++ lib.optional (builtins.pathExists hostHome) hostHome
            ++ [
              {
                home.packages = dev.extraPackages;
              }
            ];
          };
        };

      mkHost = import ./lib/mkHost.nix {
        inherit
          nixpkgs
          home-manager
          inputs
          nur
          unstable
          sharedHomeManager
          pkgs
          vars
          ;
      };
    in
    {
      nixosConfigurations = {
        gh0stk = mkHost "gh0stk";
        slime = mkHost "slime";
      };

      devShells."${system}" =
        let
          desktopShells = (getDev "desktop" true).devShells;
          serverShells = (getDev "server" false).devShells;
        in
        desktopShells // serverShells;
    };
}
