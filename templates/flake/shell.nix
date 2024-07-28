{ mkShell
, nixd
, nixpkgs-fmt
}:
mkShell {
  nativeBuildInputs = [
    # Nix
    nixpkgs-fmt
    nixd
  ];
}
