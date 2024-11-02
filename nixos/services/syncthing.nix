{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.services.syncthing.wittano;
in
{
  options.services.syncthing.wittano.enable = mkEnableOption "Enable syncthing deamon";

  config = {
    services.syncthing = {
      enable = cfg.enable;
      systemService = true;
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
          learning = {
            id = "7uub2-oxvra";
            label = "Enterprice learning projects";
            path = "~/projects/learning";
            devices = [
              "Work"
            ];
            versioning = {
              type = "trashcan";
              params = {
                keep = "3";
                cleanoutDays = "356";
              };
            };
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
          Work.id = "M3EUKVC-IYHSZZF-OFX75LZ-3E4WZAJ-PGUTYXD-FYDZSEW-GRBGRDZ-IBOHGQK";
        };
      };
    };
  };
}
