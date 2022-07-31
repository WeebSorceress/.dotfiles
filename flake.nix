{
  description = "A highly structured configuration database.";

  nixConfig.extra-experimental-features = "nix-command flakes";
  nixConfig.extra-substituters = "https://weeb-sorceress.cachix.org https://nrdxp.cachix.org https://nix-community.cachix.org";
  nixConfig.extra-trusted-public-keys = "weeb-sorceress.cachix.org-1:p4PNpfq/O/CUoVEYz7bYFBYMkmcZO85CKYGu+u4E+Rc= nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

  inputs =
    {
      # Track channels with commits tested and built by hydra
      nixos.url = "github:nixos/nixpkgs/nixos-22.05";
      latest.url = "github:nixos/nixpkgs/nixos-unstable";
      # For darwin hosts: it can be helpful to track this darwin-specific stable
      # channel equivalent to the `nixos-*` channels for NixOS. For one, these
      # channels are more likely to provide cached binaries for darwin systems.
      # But, perhaps even more usefully, it provides a place for adding
      # darwin-specific overlays and packages which could otherwise cause build
      # failures on Linux systems.
      # FIXME: disabled darwin stuff for now
      # nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";

      digga.url = "github:divnix/digga";
      digga.inputs.nixpkgs.follows = "nixos";
      digga.inputs.nixlib.follows = "nixos";
      digga.inputs.home-manager.follows = "home";
      digga.inputs.deploy.follows = "deploy";

      home.url = "github:nix-community/home-manager/release-22.05";
      home.inputs.nixpkgs.follows = "nixos";

      # FIXME: disabled darwin stuff for now
      # darwin.url = "github:LnL7/nix-darwin";
      # darwin.inputs.nixpkgs.follows = "nixpkgs-darwin-stable";

      deploy.url = "github:serokell/deploy-rs";
      deploy.inputs.nixpkgs.follows = "nixos";

      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "nixos";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "nixos";

      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "nixos";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      impermanence.url = "github:nix-community/impermanence";

      nixos-generators.url = "github:nix-community/nixos-generators";
    };

  outputs =
    { self
    , digga
    , nixos
    , home
    , nixos-hardware
    , impermanence
    , nur
    , agenix
    , nvfetcher
    , deploy
    , nixpkgs
    , ...
    } @ inputs:
    digga.lib.mkFlake
      {
        inherit self inputs;

        channelsConfig = { allowUnfree = true; };

        # FIXME: disabled darwin stuff for now
        supportedSystems = [ "x86_64-linux" ];

        channels = {
          nixos = {
            imports = [ (digga.lib.importOverlays ./overlays) ];
            overlays = [ ];
          };
          # FIXME: disabled darwin stuff for now
          # nixpkgs-darwin-stable = {
          #   imports = [ (digga.lib.importOverlays ./overlays) ];
          #   overlays = [ ];
          # };
          latest = { };
        };

        lib = import ./lib { lib = digga.lib // nixos.lib; };

        sharedOverlays = [
          (final: prev: {
            __dontExport = true;
            lib = prev.lib.extend (lfinal: lprev: {
              our = self.lib;
            });
          })

          nur.overlay
          agenix.overlay
          nvfetcher.overlay

          (import ./pkgs)
        ];

        nixos = {
          hostDefaults = {
            system = "x86_64-linux";
            channelName = "nixos";
            imports = [ (digga.lib.importExportableModules ./modules) ];
            modules = [
              { lib.our = self.lib; }
              digga.nixosModules.bootstrapIso
              digga.nixosModules.nixConfig
              impermanence.nixosModules.impermanence
              home.nixosModules.home-manager
              agenix.nixosModules.age
            ];
          };

          imports = [ (digga.lib.importHosts ./hosts/nixos) ];
          hosts = { };
          importables = rec {
            profiles = digga.lib.rakeLeaves ./profiles // {
              users = digga.lib.rakeLeaves ./users;
            };
            suites = with profiles; rec {
              main = base ++ misc ++ user;
              base = [ core.nixos ];
              misc = [ hercules-ci ];
              user = [ users.root users.siren users.witch ];
              graphical = main ++ [ gui xdg ];
              station = [ bootloader.systemd-boot filesystem.zfs ] ++ graphical;
              iso = base ++ [ users.root users.nixos ] ++ misc ++ [ bootloader.systemd-boot ];
            };
          };
        };

        # FIXME: disabled darwin stuff for now
        # darwin = {
        #   hostDefaults = {
        #     system = "x86_64-darwin";
        #     channelName = "nixpkgs-darwin-stable";
        #     imports = [ (digga.lib.importExportableModules ./modules) ];
        #     modules = [
        #       { lib.our = self.lib; }
        #       digga.darwinModules.nixConfig
        #       home.darwinModules.home-manager
        #       agenix.nixosModules.age
        #     ];
        #   };

        #   imports = [ (digga.lib.importHosts ./hosts/darwin) ];
        #   hosts = {
        #     /* set host-specific properties here */
        #     Mac = { };
        #   };
        #   importables = rec {
        #     profiles = digga.lib.rakeLeaves ./profiles // {
        #       users = digga.lib.rakeLeaves ./users;
        #     };
        #     suites = with profiles; rec {
        #       base = [ core.darwin users.darwin ];
        #     };
        #   };
        # };

        home = {
          imports = [ (digga.lib.importExportableModules ./users/modules) ];
          modules = [ impermanence.nixosModules.home-manager.impermanence ];
          importables = rec {
            profiles = digga.lib.rakeLeaves ./users/profiles;
            suites = with profiles; rec {
              base = [ direnv git ];
              siren = base ++ [ edgy ];
              witch = base ++ [ ];
              graphical = [ xdg ];
            };
          };
          users = {
            # TODO: does this naming convention still make sense with darwin support?
            #
            # - it doesn't make sense to make a 'nixos' user available on
            #   darwin, and vice versa
            #
            # - the 'nixos' user might have special significance as the default
            #   user for fresh systems
            #
            # - perhaps a system-agnostic home-manager user is more appropriate?
            #   something like 'primaryuser'?
            #
            # all that said, these only exist within the `hmUsers` attrset, so
            # it could just be left to the developer to determine what's
            # appropriate. after all, configuring these hm users is one of the
            # first steps in customizing the template.
            siren = { suites, ... }: { imports = suites.siren; };
            witch = { suites, ... }: { imports = suites.witch; };
            # FIXME: disabled darwin stuff for now
            # darwin = { suites, ... }: { imports = suites.base; };
          }; # digga.lib.importers.rakeLeaves ./users/hm;
        };

        devshell = ./shell;

        homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

        # FIXME: disabled darwin stuff for now
        # TODO: similar to the above note: does it make sense to make all of
        # these users available on all systems?
        # homeConfigurations = digga.lib.mergeAny
        #   (digga.lib.mkHomeConfigurations self.darwinConfigurations)
        #   (digga.lib.mkHomeConfigurations self.nixosConfigurations)
        # ;

        deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

      }
  ;
}
