{
  description = "cmake project for C++";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      buildInputs = with pkgs; [
        gcc
        cmake
      ];
    in
    {
      packages.x86_64-linux.default = pkgs.stdenv.mkDerivation rec {
        inherit buildInputs;

        name = "cmake++";

        src = ./.;

        installPhase = ''
          mkdir -p $out/bin

          cp ${name} $out/bin
        '';
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        inherit buildInputs;
      };
    };
}
