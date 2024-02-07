{
  description = "A simple Go package";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      package.${system} = rec {
        app = pkgs.buildGoModule {
          pname = "go-app";
          src = ./.;

          # TODO Replace SHA256
          vendorSha256 = pkgs.lib.fakeSha256;
        };
        default = app;
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
