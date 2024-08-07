{ unstable ? import <nixpkgs> { }
, callPackage
, haskell-language-server
, xmonad-with-packages
, xmonadctl
, haskellPackages
, cabal-install
, mkShell
}:
let
  nixDeps = (callPackage ./default.nix { inherit unstable; }).nativeBuildInputs;
  xmonadDevDeps = haskellPackages.ghcWithPackages (pkgs: with pkgs; [
    xmonad
    xmonad-contrib
    xmonad-extras
    xmobar
  ]);
in
mkShell {
  buildInputs = [
    # Haskell deps
    haskell-language-server
    cabal-install

    # Xmonad
    xmonadDevDeps
    xmonad-with-packages
    xmonadctl
  ] ++ nixDeps;
}
