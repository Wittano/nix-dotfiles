{
  description = "Wittano NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    filebot.url = "github:Wittano/filebot";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
    catppuccin.url = "github:catppuccin/nix";
    catppuccin-dunst = {
      url = "github:catppuccin/dunst";
      flake = false;
    };
    xmonad-contrib.url = "github:xmonad/xmonad-contrib";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      overlays = import ./overlays.nix { inherit lib inputs pkgs; };
      mkPkgs = p:
        import p {
          inherit system;

          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "electron-27.3.11"
              "electron-33.4.11"
            ];
          };

          overlays = overlays.systemOverlays;
        };

      pkgs = mkPkgs inputs.nixpkgs;
      unstable = mkPkgs inputs.nixpkgs-unstable;
      master = mkPkgs inputs.nixpkgs-master;

      lib = nixpkgs.lib.extend (sefl: super: {
        inherit (home-manager.lib) hm;

        my = import ./lib { inherit lib system inputs pkgs unstable master; };
      });
    in
    {
      lib = lib.my;

      nixosConfigurations = {
        pc = lib.my.hosts.mkHost "pc";
        laptop = lib.my.hosts.mkHost "laptop";
      };
      overlays.default = overlays.overlay;
      devShells.${system}.default = unstable.callPackage ./shell.nix { };
      templates = import ./templates.nix { inherit lib; };
    };
}
