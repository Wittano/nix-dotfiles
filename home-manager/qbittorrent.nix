{ config, lib, pkgs, ... }:
let
  qbittorrentWeb = pkgs.qbittorrent-nox;
  cfg = config.services.qbittorrent;
in
with lib;
{
  options.services.qbittorrent = {
    enable = mkEnableOption "qbittorrent";
    port = mkOption {
      type = types.port;
      default = 8080;
      description = "HTTP port for WebUI";
    };
    installDesktop = mkOption {
      type = types.bool;
      default = false;
      description = "Install desktop qbittorrent version";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.qbittorrent = {
      Unit = {
        Description = "Qbittorrent - torrent client in web-only version";
        After = [ "network.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Environment = "QBT_NO_SPLASH=1";
        ExecStart = "${meta.getExe qbittorrentWeb} --webui-port=${builtins.toString cfg.port}";
        Restart = "always";
        Type = "exec";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    home.packages = mkIf cfg.installDesktop [ pkgs.qbittorrent ];
  };
} 
