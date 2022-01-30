with import <nixpkgs> { };
mkShell { buildInputs = with pkgs; [ go_1_17 gopls nixfmt rnix-lsp ]; }
