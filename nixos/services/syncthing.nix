{ config, lib, pkgs, hostname, ... }:
with lib;
with lib.my;
let
  cfg = config.services.syncthing.wittano;
  user = if hostname == "pc" then "syncthing" else "wittano";
  group = "syncthing";
  dataDir = "/home/wittano/.cache/syncthing";
  configDir = "/home/wittano/.config/syncthing";
  package = pkgs.syncthing;

  syncthingUser = attrsets.optionalAttrs (hostname == "pc") {
    syncthing = {
      inherit group;

      uid = 1004;
      isSystemUser = true;
      homeMode = "0770";
    };
  };
in
{
  options.services.syncthing.wittano.enable = mkEnableOption "Enable syncthing deamon";

  config = mkIf cfg.enable {
    systemd.packages = [ package ];

    users.groups.${group}.gid = config.ids.gids.syncthing;

    users.users = mkMerge [
      syncthingUser
      {
        wittano.extraGroups = [
          group
        ];
      }
    ];

    systemd.services.syncthing = mkIf cfg.enable {
      description = "Syncthing service";
      after = [ "network.target" ];
      environment = {
        STNORESTART = "yes";
        STNOUPGRADE = "yes";
      };
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        SuccessExitStatus = "3 4";
        RestartForceExitStatus = "3 4";
        User = user;
        Group = group;
        ExecStart = ''
          ${package}/bin/syncthing \
            -no-browser \
            -gui-address=127.0.0.1:8384 \
            -config=${configDir} \
            -data=${dataDir} \
        '';
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = [
          "~CAP_SYS_PTRACE"
          "~CAP_SYS_ADMIN"
          "~CAP_SETGID"
          "~CAP_SETUID"
          "~CAP_SETPCAP"
          "~CAP_SYS_TIME"
          "~CAP_KILL"
        ];
      };
    };
  };
}
