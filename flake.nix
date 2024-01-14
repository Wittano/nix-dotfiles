{
  description = "Wittano NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    wittano-dotfiles = {
      url = "github:Wittano/dotfiles";
      flake = false;
    };
    wittano-repo.url = "github:Wittano/nix-repo";
    filebot.url = "github:Wittano/filebot";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    agenix.url = "github:ryantm/agenix";
    nixvim = {
      url = "github:nix-community/nixvim?ref=nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      lib = nixpkgs.lib.extend (sefl: super: {
        hm = home-manager.lib.hm;
        my = import ./lib { inherit lib system inputs; };
      });
    in
    {
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
    };
}
