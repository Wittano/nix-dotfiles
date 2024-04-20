{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    # For Qtile
    python311Packages.qtile
    python311Packages.mypy

    # Python
    python311Packages.yapf # Python Formatter
    python311Packages.isort # Python Refactor
    isort
    vscode-extensions.ms-python.vscode-pylance # Python LSP

    # Nix
    nixpkgs-fmt
    nil

    # Bash
    shellcheck
    shfmt
  ];
}
