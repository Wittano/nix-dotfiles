{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.sddm;
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

  options.modules.desktop.sddm = {
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

      enable = true;
      autoNumlock = true;
      settings = {
        General.InputMethod="";
      };
    };
  };
}
