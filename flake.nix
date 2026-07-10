{
  description = "Wittano NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    expert-ls.url = "github:elixir-lang/expert";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    filebot.url = "github:Wittano/filebot";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    catppuccin-dunst = {
      url = "github:catppuccin/dunst";
      flake = false;
    };
    xmonad-contrib.url = "github:xmonad/xmonad-contrib";
    agenix.url = "github:ryantm/agenix";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      mkPkgs =
        p:
        import p {
          inherit system;

          config.allowUnfree = true;
          overlays = import ./overlays.nix {
            inherit lib;
            pkgs = p;
          };
        };

      pkgs = mkPkgs inputs.nixpkgs;
      unstable = mkPkgs inputs.nixpkgs-unstable;
      master = mkPkgs inputs.nixpkgs-master;

      lib = nixpkgs.lib.extend (
        sefl: super: {
          inherit (home-manager.lib) hm;

          my = import ./lib {
            inherit
              lib
              pkgs
              system
              inputs
              unstable
              master
              ;
          };
        }
      );
    in
    {
      lib = lib.my;

      nixosConfigurations = {
        pc-xmonad = lib.my.hosts.mkHost "pc" "xmonad";
        pc-openbox = lib.my.hosts.mkHost "pc" "openbox";
        pc-qtile = lib.my.hosts.mkHost "pc" "qtile";
        pc-labwc = lib.my.hosts.mkHost "pc" "labwc";
        pc-bspwm = lib.my.hosts.mkHost "pc" "bspwm";

        framework-xmonad = lib.my.hosts.mkHost "framework" "xmonad";
        framework-openbox = lib.my.hosts.mkHost "framework" "openbox";
        framework-qtile = lib.my.hosts.mkHost "framework" "qtile";
        framework-labwc = lib.my.hosts.mkHost "framework" "labwc";
        framework-bspwm = lib.my.hosts.mkHost "framework" "bspwm";
      };
      devShells.${system}.default = unstable.callPackage ./shell.nix { };
      templates = import ./templates.nix { inherit lib; };
    };
}
