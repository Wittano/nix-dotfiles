{ config, pkgs, lib, home-manager, unstable, ... }:
with lib;
let cfg = config.modules.dev.pycharm;
in {
  options = {
    modules.dev.pycharm = {
      enable = mkEnableOption ''
        Enable Python development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home = {
      packages = with pkgs; [
        virtualenv
        pipenv
        python311
        jetbrains.pycharm-professional
      ];
      file.".ideavimrc".text = ''
        set rnu nu
      '';
    };
  };
}
