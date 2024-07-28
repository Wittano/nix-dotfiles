{ stdenv }: stdenv.mkDerivation {
  pname = "nix";

  src = ./.;
}
