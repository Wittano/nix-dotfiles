{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.rss;
in
{
  options = {
    modules.services.rss = {
      enable = mkEnableOption "Enable commafeed - RSS server";
    };
  };

  config = mkIf cfg.enable {
    services.commafeed.enable = true;
  };
}
