{ mkShell
, nixd
, nixpkgs-fmt
, lib
}:
with lib;
mkShell {
  nativeBuildInputs = [
    # Nix
    nixpkgs-fmt
    nixd
  ];
}
