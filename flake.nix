{
  description = "Wittano NixOS configuration";

  nixConfig = {
    trusted-substituters = [
      "https://ezkea.cachix.org"
      "https://wittano-nix-repo.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "wittano-nix-repo.cachix.org-1:SqjGwMsbzVQOXhbS90DXFC7AoGH99dzPy8zixK3cyt0="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    filebot.url = "github:Wittano/filebot";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
    honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
    catppuccin.url = "github:catppuccin/nix";
    xmonad-contrib.url = "github:xmonad/xmonad-contrib";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      overlays = import ./overlays.nix { inherit lib inputs; };
      mkPkgs = p:
        import p {
          inherit system;

          config.allowUnfree = true;
          overlays = overlays.systemOverlays;
        };

      pkgs = mkPkgs inputs.nixpkgs;
      unstable = mkPkgs inputs.nixpkgs-unstable;

      privateRepo = lib.my.pkgs.importPkgs ./pkgs;

      lib = nixpkgs.lib.extend (sefl: super: {
        hm = home-manager.lib.hm;
        my = import ./lib { inherit lib system inputs pkgs unstable privateRepo; };
      });
    in
    {
      lib = lib.my;

      nixosConfigurations = import ./nixos-configs.nix { inherit lib; };
      overlays.default = overlays.overlay;
      devShells.${system} = import ./shells.nix { inherit inputs lib system pkgs; };
      packages.${system} = privateRepo;
      templates = import ./templates.nix { inherit lib; };
    };
}
