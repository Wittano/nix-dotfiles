{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  nvidiaDriverPackage = lists.optionals config.hardware.nvidia.wittano.enable [ config.boot.kernelPackages.nvidiaPackages.stable ];

  inherit (pkgs) virtualbox;
  virtualboxPackage = lists.optionals config.virtualisation.virtualbox.host.enable [ virtualbox ];

  extraEnvPackages = [ pkgs.ocl-icd pkgs.util-linux pkgs.docker ] ++ nvidiaDriverPackage ++ virtualboxPackage;
  dockerGroup = lists.optionals config.virtualisation.docker.enable [ "docker" ];
  vboxGroup = lists.optionals config.virtualisation.virtualbox.host.enable [ "vboxusers" ];

in
{
  options.services.boinc.wittano.enable = mkEnableOption "Enable BOINC deamon";

  config = mkIf config.services.boinc.wittano.enable {
    users.users = {
      wittano.extraGroups = [ "boinc" ];
      boinc.extraGroups = dockerGroup ++ vboxGroup;
    };

    hardware.virtualization.wittano.stoppedServices = [
      "boinc.service"
    ];

    virtualisation = {
      docker.wittano.enable = true;
      virtualbox = rec {
        host = rec {
          enable = true;
          package = virtualbox;
          enableKvm = config.virtualisation.libvirtd.enable;
          addNetworkInterface = !enableKvm;
          headless = true;
        };
        guest.enable = host.enable;
      };
    };

    services.boinc = {
      inherit extraEnvPackages;

      enable = true;
      allowRemoteGuiRpc = true;
    };
  };

}
