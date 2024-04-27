{ unstable ? import <nixpkgs> { }
, mkShell
, callPackage
, python311Packages
, vscode-extensions
, isort
, ...
}:
let
  nixDeps = (callPackage ./default.nix { inherit unstable; }).nativeBuildInputs;
in
mkShell {
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
