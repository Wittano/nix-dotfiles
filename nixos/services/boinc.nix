{ config, pkgs, lib, hostname, ... }:
with lib;
with lib.my;
let
  nvidiaDriverPackage = lists.optionals (hostname != "pc") [ config.boot.kernelPackages.nvidiaPackages.stable ];
  extraEnvPackages = with pkgs; [ ocl-icd virtualbox ] ++ nvidiaDriverPackage;
  users = if hostname == "pc" then [ "wittano" "wito" ] else [ "wittano" ];
in
{
  options.services.boinc.wittano.enable = mkEnableOption "Enable BOINC deamon";

  config = mkIf config.services.boinc.wittano.enable {
    users.users = desktop.mkMultiUserHomeManager users {
      extraGroups = [ "boinc" ];
    };

    hardware.virtualization.wittano.stopServices = [{
      name = "win10";
      services = [ "boinc.service" ];
    }];

    virtualisation.virtualbox = {
      host = rec {
        enable = true;
        enableKvm = true;
        addNetworkInterface = !enableKvm;
      };
      guest.enable = true;
    };

    services.boinc = {
      inherit extraEnvPackages;

      enable = true;
      allowRemoteGuiRpc = true;
    };
  };

}
