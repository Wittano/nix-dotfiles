{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.services.syncthing.wittano;

  laptop = "Debian - Laptop";
  work = "Windows - Work";
  trueNas = "TrueNAS - Server";
  phone = "Android - Phone";
in
{
  options.services.syncthing.wittano.enable = mkEnableOption "Enable syncthing deamon";

  config = {
    services.syncthing = {
      enable = cfg.enable;
      systemService = true;
      dataDir = "/home/wittano/.cache/syncthing";
      configDir = "/home/wittano/.config/syncthing";
      user = "wittano";
      settings = {
        folders = {
          projects = {
            id = "pwxg9-eq2rf";
            label = "Programming projects";
            path = "~/projects";
            devices = [
              trueNas
              laptop
            ];
          };
          learning = {
            id = "7uub2-oxvra";
            label = "Enterprice learning projects";
            path = "~/projects/learning";
            devices = [
              work
              laptop
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
              phone
              trueNas
              laptop
            ];
          };
        };
        devices = {
          ${phone}.id = "WOQUTMO-7NJ7ONW-TMJ27JC-ENUM6QN-WE35NQO-MEUP3VQ-FEMMI2E-TCT4LQ4";
          ${trueNas}.id = "CIMVMQO-7RLKQAL-BXRS6Z3-XXFPRLB-PYHZUR3-KKH5HGX-PFWLY6S-C3KLEQ6";
          ${work}.id = "M3EUKVC-IYHSZZF-OFX75LZ-3E4WZAJ-PGUTYXD-FYDZSEW-GRBGRDZ-IBOHGQK";
          ${laptop}.id = "JAPRBPA-7KH7MCW-7TXX5WA-AYEKCC2-ACWEPAF-6SXEA3N-ELU2N7Q-TFSZ5QM";
        };
      };
    };
  };
}
