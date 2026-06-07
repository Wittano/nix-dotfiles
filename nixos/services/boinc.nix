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
  options.services.boinc.wittano = {
    enable = mkEnableOption "Enable BOINC deamon";
    enableVbox = mkEnableOption "Virtualbox support for boinc";
    enableDocker = mkEnableOption "Docker support for boinc";
  };

  config = mkIf config.services.boinc.wittano.enable {
    users.users = {
      wittano.extraGroups = [ "boinc" ];
      boinc.extraGroups = dockerGroup ++ vboxGroup;
    };

    hardware.virtualization.wittano.stoppedServices = [
      "boinc.service"
    ];

    home-manager.users.wittano.programs.fish.shellAliases = {
      boinc-config = "sudo vim /var/lib/boinc/cc_config.xml && sudo systemctl restart boinc.service";
    };

    virtualisation = {
      docker.wittano.enable = config.services.boinc.wittano.enableDocker;
      virtualbox = rec {
        host = rec {
          enable = config.services.boinc.wittano.enableVbox;
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
