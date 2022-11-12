{ config, pkgs, lib, username, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.services.boinc;
in {
  options = {
    modules.services.boinc = { enable = mkEnableOption "Enable BOINC deamon"; };
  };

  config = mkIf cfg.enable {
    users.users."${username}".extraGroups = [ "boinc" ];

    services.boinc = {
      enable = true;
      extraEnvPackages = with pkgs; [ ocl-icd ];
      allowRemoteGuiRpc = true;
    };
  };

}
