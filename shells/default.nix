{ mkShell
, nixpkgs-fmt
, nil
, shellcheck
, shfmt
, ...
}:
mkShell {
  nativeBuildInputs = [
    # Nix
    nixpkgs-fmt
    nil

    # Bash
    shellcheck
    shfmt
  ];
}
