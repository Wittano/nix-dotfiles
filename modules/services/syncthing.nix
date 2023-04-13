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
        "${homeDir}/Music" = {
          id = "epc3d-xkkkk";
          label = "Music";
          devices = [ "phone" ];
        };

        "${homeDir}/.keepass" = {
          id = "xm73k-khame";
          label = "Passwords";
          devices = [ "phone" ];
        };
      };
      devices = {
        phone = {
          # TODO Export sensitive data to secret manager
          id = "WOQUTMO-7NJ7ONW-TMJ27JC-ENUM6QN-WE35NQO-MEUP3VQ-FEMMI2E-TCT4LQ4";
        };
      };
      extraOptions = { gui.theme = "dark"; };
    };
  };
}
