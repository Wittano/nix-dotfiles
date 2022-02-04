{ config, pkgs, lib, home-manager, ... }:
with lib;
let cfg = config.modules.dev.python;
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
    home-manager.users.wittano.home = {
      packages = with pkgs; [
        virtualenv
        (mkIf cfg.usePycharm jetbrains.pycharm-community)
      ];
      file.".ideavimrc".text = ''
        set rnu nu
      '';
    };
  };
}
