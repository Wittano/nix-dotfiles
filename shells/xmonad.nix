{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    # Haskell
    ghc
    haskellPackages.haskell-language-server
    cabal-install
    cabal2nix
    stack

    # Nix
    nixpkgs-fmt
    nil

    # Bash
    shellcheck
    shfmt
  ];
}
