{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    # Nix
    nixpkgs-fmt
    nil

    # Bash
    shellcheck
    shfmt
  ];
}
