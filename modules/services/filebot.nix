{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.filebot;
in
{
  options = {
    modules.services.filebot = {
      enable = mkEnableOption "Enable filebot service";
    };
  };

  config = {
    services.filebot = {
      enable = cfg.enable;
      user = "wittano";
      # TODO export toml configuration into toml file
      configPath = mapper.toTOML "filebot.toml" {
        Pictures = {
          src = [ "$HOME/Downloads/*.(gif|jpe?g|tiff?|png|webp|bmp)" ];
          dest = "$HOME/Pictures";
        };
        ToDocument = {
          src = [ "$HOME/Downloads/*.(zip|tar*)" "$HOME/Downloads/*.pdf" ];
          dest = "$HOME/Documents";
        };
        Iso = {
          src = [ "$HOME/Downloads/*.iso" ];
          moveToTrash = true;
          after = 1;
        };
        Jars = {
          src = [ "$HOME/Downloads/*.jar" ];
          dest = "~/mc-mods";
        };
      };
    };
  };
}
