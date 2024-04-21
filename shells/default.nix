{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # Nix
    nixpkgs-fmt
    nil

    # Bash
    shellcheck
    shfmt
  ];
}
