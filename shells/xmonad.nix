{ unstable ? import <nixpkgs> { }, haskell-language-server, xmonad-with-packages, xmonadctl, haskellPackages }:
let
  nixDeps = (unstable.callPackage ./default.nix { }).nativeBuildInputs;
  xmonadDevDeps = haskellPackages.ghcWithPackages (pkgs: with pkgs; [
    cabal-install
    cabal2nix
    stack

    # Xmonad
    xmonad
    xmonad-contrib
    xmonad-extras
    xmobar
  ]);
in
unstable.mkShell {
  buildInputs = [
    # Haskell deps
    haskell-language-server

    # Xmonad
    xmonadDevDeps
    xmonad-with-packages
    xmonadctl
  ] ++ nixDeps;
}
