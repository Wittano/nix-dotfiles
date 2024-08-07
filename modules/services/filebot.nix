{ config, lib, inputs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.filebot;
  homeDir = config.home-manager.users.wittano.home.homeDirectory;
in
{
  options = {
    modules.services.filebot = {
      enable = mkEnableOption "Enable filebot service";
    };
  };

  imports = [
    inputs.filebot.nixosModules.default
  ];

  config = {
    modules.dev.lang.ides = [ "go" ];

    modules.hardware.virtualization.stopServices = [{
      name = "win10";
      services = [ "fielbot.service" ];
    }];

    services.filebot = {
      enable = cfg.enable;
      user = "wittano";
      updateInterval = "1m";
      configPath = mapper.toTOML "filebot.toml" {
        Pictures = {
          src = [ "${homeDir}/Downloads/*.(gif|jpe?g|tiff?|png|webp|bmp)" ];
          dest = "${homeDir}/Pictures";
        };
        Docs = {
          src = [ "${homeDir}/Downloads/*.(zip|tar*)" "${homeDir}/Downloads/*.pdf" ];
          dest = "${homeDir}/Documents";
        };
        Iso = {
          src = [ "${homeDir}/Downloads/*.iso" ];
          moveToTrash = true;
          after = 1;
        };
      };
    };
  };
}
