{ lib, config, ... }: with lib;
{
  options.services.mako.wittano.enable = mkEnableOption "mako";

  config = mkIf config.services.mako.wittano.enable {
    services.mako = {
      enable = true;
      settings.font = "Jetbrains Mono 14";
    };
  };
}
