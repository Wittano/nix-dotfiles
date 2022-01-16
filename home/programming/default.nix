{ config, pkgs, ... }: {
  imports = [ ./java.nix ./python.nix ];

  home.packages = with pkgs; [ zeal ];

}
