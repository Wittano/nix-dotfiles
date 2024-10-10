{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.syncthing;
  homeDir = config.home-manager.users.wittano.home.homeDirectory;
in
{
  options = {
    modules.services.syncthing = {
      enable = mkEnableOption "Enable syncthing deamon";
    };
  };

  config = {
    services.syncthing = {
      enable = cfg.enable;
      systemService = true;
      dataDir = "${homeDir}/.cache/syncthing";
      configDir = "${homeDir}/.config/syncthing";
      user = "wittano";
      settings = {
        folders = {
          projects = {
            id = "pwxg9-eq2rf";
            label = "Programming projects";
            path = "~/projects";
            devices = [
              "TrueNAS"
            ];
          };
          sync = {
            id = "default";
            label = "Sync folder";
            path = "~/Sync";
            devices = [
              "Phone"
              "TrueNAS"
              "Win10VM"
            ];
          };
          openttd = {
            id = "dmzkg-75il2";
            path = "~/.local/share/openttd/save/multi";
            label = "OpenTTD - multiplayer saves";
            devices = [
              "Karol"
            ];
            versioning = {
              type = "trashcan";
              params = {
                keep = "5";
                cleanoutDays = "356";
              };
            };
          };
        };
        devices = {
          Phone.id = "WOQUTMO-7NJ7ONW-TMJ27JC-ENUM6QN-WE35NQO-MEUP3VQ-FEMMI2E-TCT4LQ4";
          TrueNAS.id = "CIMVMQO-7RLKQAL-BXRS6Z3-XXFPRLB-PYHZUR3-KKH5HGX-PFWLY6S-C3KLEQ6";
          Karol.id = "F7EH7MZ-N5VYRKT-IA2XWJG-I7SPGDP-RDVSZCU-WTCI534-NQPF7I2-KLE6IQL";
          Win10VM.id = "4KACCLO-MJCLRTA-2TOCUIE-4CNJL3W-EWUDXIR-2MIPHNC-HMZPQFP-IYTOHAW";
        };
        extraOptions.gui.theme = "dark";
      };
    };
  };
}
