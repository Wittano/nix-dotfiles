{ pkgs ? import <nixpkgs> { } }:
with pkgs;

mkShell { buildInputs = [ rnix-lsp nixfmt ]; }
