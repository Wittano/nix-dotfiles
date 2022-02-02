{ config, pkgs, lib, home-manager, mainUser, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.dev.python;

  pycharmPackages = with pkgs; [ jetbrains.pycharm-community ];
in {
  options = {
    modules.dev.python = {
      enable = mkEnableOption ''
        Enable Java development enviroment
      '';

      usePycharm = mkEnableOption ''
        Enable Pycharm as default IDE
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${mainUser}.home = {
      packages = with pkgs;
        [ virtualenv ] ++ (mkIf cfg.usePycharm pycharmPackages);
      file.".ideavimrc".text = ''
        set rnu nu
      '';
    };
  };
}
