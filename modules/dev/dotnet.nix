{ config, lib, pkgs, home-manger, ... }:
with lib;
let cfg = config.modules.dev.dotnet;
in {
  options = {
    modules.dev.dotnet = {
      enable = mkEnableOption ''
        Enable .NET development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.variables.DOTNET_CLI_TELEMETRY_OPTOUT = "0";

    home-manager.users.wittano.home.packages = with pkgs; [
      dotnet-sdk
      mono
      jetbrains.rider
    ];
  };
}
