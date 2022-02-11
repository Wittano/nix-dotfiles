{
  description = "Wittano NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wittano-dotfiles = {
      url = "github:Wittano/dotfiles";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, wittano-dotfiles, ... }@inputs:
    let
      inherit (builtins) path;
      inherit (lib.my.hosts) mkHost;

      system = "x86_64-linux";

      mkPkgs = p:
        import p {
          inherit system;

          config.allowUnfree = true;
        };

      pkgs = mkPkgs nixpkgs;
      unstable = mkPkgs nixpkgs-unstable;

      dotfiles = {
        rofi = "${wittano-dotfiles}/rofi";
        alacritty = "${wittano-dotfiles}/alacritty";
      };

      lib = nixpkgs.lib.extend (sefl: super: {
        hm = home-manager.lib.hm;
        my = import ./lib { inherit lib pkgs system home-manager unstable dotfiles; };
      });
    in {
      inherit lib;

      nixosConfigurations = builtins.listToAttrs [rec {
        name = "pc";
        value = mkHost name;
      }];
    };
}
