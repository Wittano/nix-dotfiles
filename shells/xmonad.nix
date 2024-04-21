{ pkgs ? import <nixpkgs> { } }:
let
  nixDeps = (pkgs.callPackage ./default.nix { }).nativeBuildInputs;
  xmonadDevDeps = pkgs.haskellPackages.ghcWithPackages (pkgs: with pkgs; [
    cabal-install
    cabal2nix
    stack

    # Xmonad
    xmonad
    xmonad-contrib
  ]);
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # Haskell deps
    haskell-language-server

    # Xmonad
    xmonadDevDeps
    xmonad-with-packages
    xmonadctl
    xmonad-log
  ] ++ nixDeps;
}
