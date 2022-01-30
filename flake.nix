{
  description = "Wittano NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";

      mkPkgs = p:
        import p {
          inherit system;
          config.allowUnfree = true;
        };

      pkgs = mkPkgs nixpkgs;
      unstable = mkPkgs nixpkgs-unstable;

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs;
          lib = self;
        };
      });
    in {
      lib = lib.my;

      nixosConfigurations = with lib; {
        pc = nixosSystem {
          inherit system;
          specialArgs = { inherit pkgs unstable lib; };

          modules = [
            ./modules/configuration.nix
            ./modules/hardware
            ./modules/networking/networking.nix
            ./modules/services
            ./modules/desktop/openbox.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit pkgs unstable lib; };
                useUserPackages = true;
                backupFileExtension = "backup";
                users.wittano = ./hosts/pc/home.nix;
              };
            }
          ];
        };
      };
    };
}
