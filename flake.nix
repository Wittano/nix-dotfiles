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
    oldNixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    filebot.url = "github:Wittano/filebot";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
    honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      wittanoOverlay = _: _: privateRepo;

      mkPkgs = p:
        import p {
          inherit system;

          config.allowUnfree = true;
          overlays = [ wittanoOverlay ];
        };

      pkgs = mkPkgs inputs.nixpkgs;
      unstable = mkPkgs inputs.nixpkgs-unstable;
      oldPkgs = mkPkgs inputs.oldNixpkgs;

      privateRepo = lib.my.pkgs.importPkgs ./pkgs;

      lib = nixpkgs.lib.extend (sefl: super: {
        hm = home-manager.lib.hm;
        my = import ./lib { inherit lib system inputs pkgs unstable privateRepo oldPkgs; };
      });

      templatesDirs = builtins.attrNames
        (lib.filterAttrs (n: v: v == "directory")
          (builtins.readDir ./templates));

      templates = lib.lists.forEach templatesDirs (name: {
        inherit name;

        value = {
          path = ./templates/${name};
          description = "Template for ${name}";
        };
      });

      devShells =
        let
          shellPkgs = import inputs.nixpkgs-unstable {
            inherit system;

            config = {
              allowUnfree = true;
              allowBroken = true;
            };
          };
          names = lib.my.string.mkNixNamesFromDir ./shells;
          mkShellAttrs = name: {
            inherit name;
            value = pkgs.callPackage (./shells + "/${name}.nix") { unstable = shellPkgs; };
          };
          shells = builtins.listToAttrs (builtins.map mkShellAttrs names);
        in
        shells;
    in
    {
      lib = lib.my;

      nixosConfigurations =
        let
          inherit (lib.attrsets) nameValuePair;
          inherit (lib.my.hosts) mkHost;
          inherit (lib.lists) flatten;

          hosts = builtins.attrNames (builtins.readDir ./hosts);
          desktopHosts = lib.my.string.mkNixNamesFromDir ./modules/desktop/wm;

          finalHosts = (flatten (builtins.map (x: builtins.map (d: "${x}-${d}") desktopHosts) hosts)) ++ hosts;

          devHosts = builtins.listToAttrs (builtins.map
            (n:
              let devName = "${n}-dev";
              in
              nameValuePair (devName) (mkHost {
                name = devName;
                isDevMode = true;
              }))
            finalHosts);

          normalHosts = builtins.listToAttrs (builtins.map
            (name: {
              inherit name;
              value = mkHost { inherit name; };
            })
            finalHosts);
        in
        normalHosts // devHosts;

      overlays.default = wittanoOverlay;
      devShells.${pkgs.system} = devShells;
      packages.${system} = privateRepo;
      templates = builtins.listToAttrs templates;
    };
}
