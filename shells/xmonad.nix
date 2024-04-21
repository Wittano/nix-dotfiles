{ pkgs ? import <nixpkgs> { } }:
let
  nixDeps = (pkgs.callPackage ./default.nix { }).nativeBuildInputs;
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    ghc
    haskellPackages.haskell-language-server
    cabal-install
    cabal2nix
    stack
  ] ++ nixDeps;
}
