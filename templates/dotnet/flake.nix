{
  description = "dotnet";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      sdk = pkgs.dotnetCorePackages.dotnet_8.sdk;
    in
    {
      packages.${system}.default = pkgs.callPackage ./default.nix { };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Nix
          nixpkgs-fmt
          nixd

          # Dotnet
          sdk
        ];

        shellHook = ''
          # Disable telemetry
          export DOTNET_CLI_TELEMETRY_OPTOUT="0";
        
          export DOTNET_ROOT="${sdk}";
        '';
      };
    };
}
