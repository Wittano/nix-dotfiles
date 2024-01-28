{ pkgs, lib, config, home-manager, ... }:
with lib;
with lib.my;
with builtins;
let
  cfg = config.modules.dev.rust;
  pRustCommand = commands.createProjectJumpCommand config "$HOME/projects/own/rust";
in
{
  options = {
    modules.dev.rust = {
      enable = mkEnableOption "Enable rust IDE";
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    pRustCommand
    {
      home-manager.users.wittano.home.packages = with pkgs; [ jetbrains.rust-rover ];
    }
  ]);
}

