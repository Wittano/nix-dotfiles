{ config, lib, inputs, ... }:
with lib;
with lib.my;
let
  homeDir = config.home-manager.users.wittano.home.homeDirectory;
in
{
  options.services.filebot.wittano.enable = mkEnableOption "Enable filebot service";

  imports = [
    inputs.filebot.nixosModules.default
  ];

  config = mkIf config.services.filebot.wittano.enable {
    hardware.virtualization.wittano.stopServices = [{
      name = "win10";
      services = [ "fielbot.service" ];
    }];

    services.filebot = {
      enable = true;
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
