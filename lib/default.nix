{ lib, ... }: { path = import ./path.nix { inherit lib; }; }
