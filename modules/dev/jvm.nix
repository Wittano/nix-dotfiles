{ config, pkgs, lib, home-manager, username, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.dev.jvm;
in
{
  options = {
    modules.dev.jvm = {
      enable = mkEnableOption ''
        Enable JVM development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [ jetbrains.idea-ultimate jdk gradle ];
        file.".ideavimrc".text = ''
          set rnu nu
        '';
      };
    };

    systemd.user.services.gradle = {
      description = ''
        Gradle - tools to buliding JVM application. Adaptable, fast automation for all
      '';
      wantedBy = [ "multi-user.target" ];
      script = "${pkgs.gradle}/bin/gradle --foreground";
      postStop = "${pkgs.gradle}/bin/gradle --stop";
    };
  };
}
