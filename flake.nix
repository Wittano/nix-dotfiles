{
  description = "Wittano NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wittano-dotfiles = {
      url = "github:Wittano/dotfiles";
      flake = false;
    };
    system-staff = {
      url = "github:Wittano/system-staff";
      flake = false;
    };
  };

  outputs = { self,
              nixpkgs,
              home-manager,
              nixpkgs-unstable,
              wittano-dotfiles,
              system-staff,
              ... }@inputs:
    let
      inherit (lib.my.hosts) mkHost;
      inherit (lib.my.mapper) mapDirToAttrs;

      system = "x86_64-linux";

      mkPkgs = p:
        import p {
          inherit system;

          config.allowUnfree = true;
        };

      pkgs = mkPkgs nixpkgs;
      unstable = mkPkgs nixpkgs-unstable;

      dotfiles = mapDirToAttrs wittano-dotfiles;

      systemStaff = mapDirToAttrs system-staff;

      lib = nixpkgs.lib.extend (sefl: super: {
        hm = home-manager.lib.hm;
        my = import ./lib {
          inherit lib pkgs system home-manager unstable dotfiles systemStaff;
        };
      });
    in {
      inherit lib;

      nixosConfigurations =
        let
          inherit (lib.attrsets) mapAttrs' nameValuePair;

          hosts = builtins.readDir ./hosts;
          devHosts = mapAttrs' (n: v:
            let
              devName = "${n}-dev";
            in
              nameValuePair (devName) (mkHost { name = devName; isDevMode = true; } )) hosts;
          normalHosts = builtins.mapAttrs (n: v: mkHost { name = n; } ) hosts;
        in
          normalHosts // devHosts;
    };
}
