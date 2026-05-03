{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

      extra_pkg_config = {
        allowUnfree = true;
      };

      dependencyOverlays = # (import ./overlays inputs) ++
        [
          (utils.standardPluginOverlay inputs)
        ];

      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkPlugin,
          ...
        }@packageDef:
        {
          lspsAndRuntimeDeps = with pkgs; {
            general = [
              stdenv.cc.cc
              typescript
              codesnap
              tree-sitter
              go
              php
              delve
            ];
          };

          startupPlugins = with pkgs.vimPlugins; {
            general = [
              lazy-nvim
              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
            ];
          };

          optionalPlugins = { };

          sharedLibraries = {
            general = with pkgs; [
              # libgit2
            ];
          };

          environmentVariables = {
            test = {
              CATTESTVAR = "It worked!";
            };
          };

          extraWrapperArgs = {
            test = [
              ''--set CATTESTVAR2 "It worked again!"''
            ];
          };

          python3.libraries = {
            test = (_: [ ]);
          };
          extraLuaPackages = {
            test = [ (_: [ ]) ];
          };
        };

      packageDefinitions = {
        nvim =
          { pkgs, name, ... }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              aliases = [ "vim" ];
              hosts.python3.enable = true;
              hosts.node.enable = true;
            };
            categories = {
              general = true;
              have_nerd_font = false;

              # example = {
              #   youCan = "add more than just booleans";
              #   toThisSet = [
              #     "and the contents of this categories set"
              #     "will be accessible to your lua with"
              #     "nixCats('path.to.value')"
              #     "see :help nixCats"
              #     "and type :NixCats to see the categories set in nvim"
              #   ];
              # };
            };
          };
      };
      defaultPackageName = "nvim";
    in
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = utils.mkAllWithDefault defaultPackage;

        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = "";
          };
        };

      }
    )
    // (
      let
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );
}
