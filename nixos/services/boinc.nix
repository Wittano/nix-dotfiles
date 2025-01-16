{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  nvidiaDriverPackage = lists.optionals config.hardware.nvidia.enable [ config.boot.kernelPackages.nvidiaPackages.stable ];
  extraEnvPackages = with pkgs; [ ocl-icd ] ++ nvidiaDriverPackage;
in
{
  options.services.boinc.wittano.enable = mkEnableOption "Enable BOINC deamon";

  config = mkIf config.services.boinc.wittano.enable {
    users.users = desktop.mkMultiUserHomeManager [ "wittano" "wito" ] {
      extraGroups = [ "boinc" ];
    };

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
