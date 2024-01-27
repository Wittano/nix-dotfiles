{ config, lib, pkgs, home-manger, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.dotnet;
  pdotnetCommand = commands.createProjectJumpCommand config "$HOME/projects/own/dotnet";
in
{
  options = {
    modules.dev.dotnet = {
      enable = mkEnableOption ''
        Enable .NET development enviroment
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    pdotnetCommand
    {
      environment.variables.DOTNET_CLI_TELEMETRY_OPTOUT = "0";

      home-manager.users.wittano.home.packages = with pkgs; [ dotnet-sdk mono jetbrains.rider ];
    }
  ]);
}
