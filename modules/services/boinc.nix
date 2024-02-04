{ config, pkgs, lib, unstable, ... }:
with lib;
let
  cfg = config.modules.services.boinc;
  # This nvidia driver replaced from stable to unstable channel, because during compilation driver had unknonw symbols
  # TODO Retrun to stable version of driver, when it'll fix (04.02.2024)
  nvidiaDriverPackage = lists.optionals
    config.modules.hardware.nvidia.enable
    [ config.boot.kernelPackages.nvidiaPackages.stable ];
  extraEnvPackages = with pkgs; [ ocl-icd ] ++ nvidiaDriverPackage;
in
{
  options = {
    modules.services.boinc = { enable = mkEnableOption "Enable BOINC deamon"; };
  };

  config = mkIf cfg.enable {
    users.users.wittano.extraGroups = [ "boinc" ];

    services.boinc = {
      inherit extraEnvPackages;

      enable = true;
      allowRemoteGuiRpc = true;
    };
  };

}
