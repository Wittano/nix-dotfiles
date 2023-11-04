{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  homeDir = "/home/wittano";
  cfg = config.modules.services.syncthing;
in
{
  options = {
    modules.services.syncthing = {
      enable = mkEnableOption ''
        Enable syncthing deamon
      '';
    };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      systemService = true;
      configDir = "${homeDir}/.config/syncthing";
      user = "wittano";
      folders = {
        "${homeDir}/.keepass" = {
          id = "xm73k-khame";
          label = "Passwords";
          devices = [ "Phone" "Server - TrueNAS" ];
        };

        "${homeDir}/Documents/notes" = {
          id = "cmk22-zz4qu";
          label = "Notes";
          devices = [ "Phone" ];
        };

        "${homeDir}/Sync" = {
          id = "default";
          label = "Sync folder";
          devices = [ "Phone" "Server - TrueNAS" ];
        };
      };
      devices = {
        Phone = {
          id = "WOQUTMO-7NJ7ONW-TMJ27JC-ENUM6QN-WE35NQO-MEUP3VQ-FEMMI2E-TCT4LQ4";
        };
        "Server - TrueNAS" = {
          id = "CIMVMQO-7RLKQAL-BXRS6Z3-XXFPRLB-PYHZUR3-KKH5HGX-PFWLY6S-C3KLEQ6";
        };
      };
      extraOptions = { gui.theme = "dark"; };
    };
  };
}
