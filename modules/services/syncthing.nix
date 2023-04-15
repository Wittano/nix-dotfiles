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
          devices = [ "Phone" ];
        };

        "${homeDir}/Documents/notes" = {
          id = "cmk22-zz4qu";
          label = "Notes";
          devices = [ "Phone" ];
        };

        "${homeDir}/Sync" = {
          id = "default";
          label = "Sync folder";
          devices = [ "Phone" ];
        };

        "/mnt/windows" = {
          id = "bkono-cnxed";
          label = "Windows VM";
          devices = [ "Windows VM" ];
        };
      };
      devices = {
        Phone = {
          id = "WOQUTMO-7NJ7ONW-TMJ27JC-ENUM6QN-WE35NQO-MEUP3VQ-FEMMI2E-TCT4LQ4";
        };
        "Windows VM" = {
          id = "AWPKKY3-4HT6T7P-4M5H6TA-C4Y4NZ4-WBXJWYJ-AVDIW5C-3OSNO5B-FMZCSAD";
        };
      };
      extraOptions = { gui.theme = "dark"; };
    };
  };
}
