with (import (fetchTarball
  "https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz") { });
mkShell { buildInputs = with pkgs; [ rnix-lsp nixfmt nixpkgs-fmt ]; }
