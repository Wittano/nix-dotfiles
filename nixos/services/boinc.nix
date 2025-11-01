{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  nvidiaDriverPackage = lists.optionals config.hardware.nvidia.wittano.enable [ config.boot.kernelPackages.nvidiaPackages.stable ];

  inherit (pkgs) virtualbox;
  virtualboxPackage = lists.optionals (!config.hardware.virtualization.wittano.enableWindowsVM) [ virtualbox ];

  extraEnvPackages = [ pkgs.ocl-icd ] ++ nvidiaDriverPackage ++ virtualboxPackage;
in
{
  options.services.boinc.wittano.enable = mkEnableOption "Enable BOINC deamon";

  config = mkIf config.services.boinc.wittano.enable {
    users.users.wittano.extraGroups = [ "boinc" ];

    hardware.virtualization.wittano.stoppedServices = [
      "boinc.service"
    ];

    virtualisation.virtualbox = rec {
      host = rec {
        enable = !config.hardware.virtualization.wittano.enableWindowsVM;
        package = virtualbox;
        enableKvm = config.virtualisation.libvirtd.enable;
        addNetworkInterface = !enableKvm;
      };
      guest.enable = host.enable;
    };

    services.boinc = {
      inherit extraEnvPackages;

      enable = true;
      allowRemoteGuiRpc = true;
    };
  };

}
