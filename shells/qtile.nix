{ unstable ? import <nixpkgs> { }
, mkShell
, callPackage
, python3
, pipenv
, ...
}:
let
  nixDeps = (callPackage ./default.nix { inherit unstable; }).nativeBuildInputs;
in
mkShell {
  nativeBuildInputs = [
    # Python
    python3
    pipenv
  ] ++ nixDeps;
}
