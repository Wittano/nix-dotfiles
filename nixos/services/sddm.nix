{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.displayManager.sddm.wittano;
  theme = trivial.pipe (cfg.package + "/share/sddm/themes") [
    builtins.readDir
    builtins.attrNames
    builtins.head
  ];

  extraPackages = trivial.pipe cfg.package [
    builtins.attrNames
    (builtins.filter (strings.hasPrefix "propagated"))
    (builtins.map (x: cfg.package."${x}"))
    lists.flatten
  ];
in
{

  options.services.displayManager.sddm.wittano = {
    enable = mkEnableOption "Enable SDDM as display manager";
    package = mkOption {
      type = types.package;
      example = pkgs.dexy;
      description = "Package of sddm theme";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.displayManager.sddm = {
      inherit theme extraPackages;

      package = pkgs.kdePackages.sddm;
      enable = true;
      autoNumlock = true;
      settings = {
        General.InputMethod = "";
      };
    };
  };
}
