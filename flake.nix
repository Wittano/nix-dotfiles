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
    in {
      nixosConfigurations = with nixpkgs.lib; {
        pc = nixosSystem {
          inherit system;
          specialArgs = { unstable = unstable; };

          modules = [
            ./os/configuration.nix
            ./os/hardware.nix
            ./os/nix.nix
            ./os/networking.nix
            ./os/services

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit unstable; };
                useUserPackages = true;
                backupFileExtension = "backup";
                users.wittano = ./home/home.nix;
              };
            }
          ];
        };
      };
    };
}
