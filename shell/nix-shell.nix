with (import (fetchTarball
  "https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz") { });
pkgs.mkShell {
  buildInputs = with pkgs; [ rnix-lsp nixfmt ];
}