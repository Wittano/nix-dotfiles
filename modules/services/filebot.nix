{ config, pkgs, lib, username, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.services.filebot;
in
{
  options = {
    modules.services.filebot = { enable = mkEnableOption "Enable filebot service"; };
  };

  config = {
    services.filebot = {
      enable = cfg.enable;
      user = username;
      configPath = builtins.toFile "config.toml" ''
        [Pictures]
        src = [ "$HOME/Downloads/*.(gif|jpe?g|tiff?|png|webp|bmp)" ]
        dest = "$HOME/Pictures"

        [Archives]
        src = [ "$HOME/Downloads/*.(zip|tar*)" ]
        dest = "$HOME/Documents"
      '';
    };
  };
}