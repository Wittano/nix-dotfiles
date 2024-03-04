{
  description = "Basic Scala project template";

  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [ temurin-bin-17 scala_3 scala-cli sbt-with-scala-native ];
      };
    };
}
