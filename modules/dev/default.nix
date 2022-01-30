{ config, pkgs, ... }: {
  imports = [ ./python.nix ./go.nix ];

  home.packages = with pkgs; [ zeal ];

}
