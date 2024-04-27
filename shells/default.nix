{ unstable ? import <nixpkgs> { } }:
unstable.mkShell {
  nativeBuildInputs = with unstable; [
    # Nix
    nixpkgs-fmt
    nil

    # Bash
    shellcheck
    shfmt
  ];
}
