{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.boinc;
  nvidiaDriverPackage = lists.optionals
    config.modules.hardware.nvidia.enable
    [ config.boot.kernelPackages.nvidiaPackages.stable ];
  extraEnvPackages = with pkgs; [ ocl-icd ] ++ nvidiaDriverPackage;
in
{
  options = {
    modules.services.boinc = {
      enable = mkEnableOption "Enable BOINC deamon";
    };
  };

  config = mkIf cfg.enable {
    users.users.wittano.extraGroups = [ "boinc" ];

    modules.hardware.virtualization.stopServices = [{
      name = "win10";
      services = [ "boinc.service" ];
    }];

    services.boinc = {
      inherit extraEnvPackages;

      enable = true;
      allowRemoteGuiRpc = true;
    };
  };

}
