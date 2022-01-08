with (import (fetchTarball
  "https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz") { });
pkgs.mkShell {
  imports = [ ./nix-shell.nix ];

  buildInputs = with pkgs; [ go_1_17 gopls makeWrapper ];
}
