{
  description = "Wittano NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
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
    wittano-repo = {
      url = "github:Wittano/nix-repo";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixpkgs-unstable
    , wittano-dotfiles
    , system-staff
    , wittano-repo
    , emacs-overlay
    , ...
    }@inputs:
    let
      inherit (lib.my.hosts) mkHost;
      inherit (lib.my.mapper) mapDirToAttrs;

      system = "x86_64-linux";

      mkPkgs = p:
        import p {
          inherit system;

          config.allowUnfree = true;

          nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

          # TODO Add cachix repository for wittano-repo
          settings = {
            substituters = [
              "https://wittano.cachix.org"
              "https://nix-community.cachix.org"
              "https://cache.nixos.org/"
            ];
            trusted-public-keys = [
              "wittano.cachix.org-1:fCQ8OZR/eyQc5ic1Ra6PIDQc0cox7bjS+S89DVnojgA="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
          };
        };

      pkgs = mkPkgs nixpkgs;
      unstable = mkPkgs nixpkgs-unstable;

      dotfiles = mapDirToAttrs wittano-dotfiles;

      systemStaff = mapDirToAttrs system-staff;

      lib = nixpkgs.lib.extend (sefl: super: {
        hm = home-manager.lib.hm;
        my = import ./lib {
          inherit lib pkgs system home-manager unstable dotfiles systemStaff;
          wittanoRepo = wittano-repo;
        };
      });
    in
    {
      inherit lib;

      nixosConfigurations =
        let
          inherit (lib.attrsets) mapAttrs' nameValuePair;

          hosts = builtins.readDir ./hosts;
          devHosts = mapAttrs'
            (n: v:
              let devName = "${n}-dev";
              in nameValuePair (devName) (mkHost {
                name = devName;
                isDevMode = true;
              }))
            hosts;
          normalHosts = builtins.mapAttrs (n: v: mkHost { name = n; }) hosts;
        in
        normalHosts // devHosts;
    };
}
