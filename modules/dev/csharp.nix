{ config, lib, pkgs, home-manger, ... }:
with lib;
let cfg = config.modules.dev.csharp;
in {
  options = {
    modules.dev.csharp = {
      enable = mkEnableOption ''
        Enable C# development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.variables.DOTNET_CLI_TELEMETRY_OPTOUT = "0";

    home-manager.users.wittano.home.packages = with pkgs; [
      dotnet-sdk
      jetbrains.rider
    ];
  };
}
