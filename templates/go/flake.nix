{
  description = "A simple Go package";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      package.${system}.default = pkgs.buildGoModule {
        pname = "go-app";
        src = ./.;

        vendorSha256 = pkgs.lib.fakeSha256;
      };

      devShells.${system}.default = pkgs.mkShell {
        hardeningDisable = [ "all" ];

        DEBUG_ARGS = "";

        buildInputs = with pkgs; [
          go
          gotools
          gnumake
        ];
      };
    };

}
