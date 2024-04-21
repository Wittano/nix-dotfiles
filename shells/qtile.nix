{ pkgs ? import <nixpkgs> { } }:
let
  nixDeps = (pkgs.callPackage ./default.nix { }).nativeBuildInputs;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # For Qtile
    python311Packages.qtile
    python311Packages.mypy

    # Python
    python311Packages.yapf # Python Formatter
    python311Packages.isort # Python Refactor
    isort
    vscode-extensions.ms-python.vscode-pylance # Python LSP
  ] ++ nixDeps;
}
