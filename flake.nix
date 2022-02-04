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
      inherit (lib) nixosSystem;
      inherit (builtins) path;

      system = "x86_64-linux";

      mkPkgs = p:
        import p {
          inherit system;

          config.allowUnfree = true;
        };

      pkgs = mkPkgs nixpkgs;
      unstable = mkPkgs nixpkgs-unstable;

      lib = nixpkgs.lib.extend (sefl: super: {
        hm = home-manager.lib.hm;
        my = import ./lib { inherit lib pkgs; };
      });
    in {
      inherit lib;

      nixosConfigurations = {
        pc = nixosSystem {
          inherit system;

          specialArgs = { inherit pkgs unstable lib; };

          modules = [
            ./modules
            ./configuration.nix
            ./hosts/pc/configuration.nix

            home-manager.nixosModules.home-manager
          ];
        };

        laptop = nixosSystem {
          inherit system;
          specialArgs = { inherit pkgs unstable lib; };

          modules = [
            ./hosts/laptop

            home-manager.nixosModules

            {
              home-manager = {
                extraSpecialArgs = { inherit pkgs unstable lib; };
                useUserPackages = true;
                backupFileExtension = "backup";
                users.wittano = ./home/pc/home.nix;
              };
            }
          ];
        };
      };
    };
}
