{ config, pkgs, lib, ... }:
with lib;
let
  nvidiaDriverPackage = lists.optionals config.hardware.nvidia.enable [ config.boot.kernelPackages.nvidiaPackages.stable ];
  extraEnvPackages = with pkgs; [ ocl-icd ] ++ nvidiaDriverPackage;
in
{
  options.services.boinc.wittano.enable = mkEnableOption "Enable BOINC deamon";

  config = mkIf config.services.boinc.wittano.enable {
    users.users.wittano.extraGroups = [ "boinc" ];

    hardware.virtualization.wittano.stopServices = [{
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
