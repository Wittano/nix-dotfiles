{ unstable ? import <nixpkgs> { }, python311Packages, vscode-extensions, isort, ... }:
let
  nixDeps = (unstable.callPackage ./default.nix { }).nativeBuildInputs;
in
unstable.mkShell {
  nativeBuildInputs = with python311Packages; [
    # For Qtile
    qtile
    mypy

    # Python
    yapf # Python Formatter
    isort # Python Refactor
    isort
    vscode-extensions.ms-python.vscode-pylance # Python LSP
  ] ++ nixDeps;
}
