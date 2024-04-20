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
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    filebot.url = "github:Wittano/filebot";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    agenix.url = "github:ryantm/agenix";
    nixvim = {
      url = "github:nix-community/nixvim?ref=nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    honkai-railway-grub-theme.url = "github:voidlhf/StarRailGrubThemes";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      mkPkgs = p:
        import p {
          inherit system;

          config.allowUnfree = true;
        };

      pkgs = mkPkgs inputs.nixpkgs;
      unstable = mkPkgs inputs.nixpkgs-unstable;

      privateRepo = lib.my.pkgs.importPkgs ./pkgs;

      lib = nixpkgs.lib.extend (sefl: super: {
        hm = home-manager.lib.hm;
        my = import ./lib { inherit lib system inputs pkgs unstable privateRepo; };
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

      shellPkgs = import inputs.nixpkgs-unstable {
          inherit system;
          
          config = {
            allowUnfree = true;
            allowBroken = true;
          };
        };

      devShells = let 
        names = builtins.attrNames (builtins.readDir ./shells);
        mkShellAttrs = name: lib.attrsets.nameValuePair 
        (builtins.replaceStrings [".nix"] [""] name) 
        (import ./shells + "/${name}.nix" {pkgs = shellPkgs; });
        shells = builtins.listToAttrs (builtins.map mkShellAttrs names);
      in shells;
    in
    {
      lib = lib.my;

      nixosConfigurations =
        let
          inherit (lib.attrsets) mapAttrs' nameValuePair;
          inherit (lib.my.hosts) mkHost;

          hosts = builtins.readDir ./hosts;
          devHosts = mapAttrs'
            (n: v:
              let devName = "${n}-dev";
              in
              nameValuePair (devName) (mkHost {
                name = devName;
                isDevMode = true;
              }))
            hosts;
          normalHosts = builtins.mapAttrs (n: v: mkHost { name = n; }) hosts;
        in
        normalHosts // devHosts;

      devShells.${pkgs.system} = devShells // {
        default = import ./shells/nix.nix {pkgs = shellPkgs;};
      };

      packages.x86_64-linux = privateRepo;

      templates = builtins.listToAttrs templates;
    };
}
