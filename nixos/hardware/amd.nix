{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.amd;
in
{
  options.hardware.amd.enable = mkEnableOption "Enable AMD drivers";

  config = mkIf cfg.enable {
    services.xserver = {
      videoDrivers = mkIf config.services.xserver.enable [ "amdgpu" ];
      config = mkIf (config.home-manager.users.wittano.programs.games.enable || config.programs.steam.enable) ''
        Section "OutputClass"
         Identifier "AMD"
         MatchDriver "amdgpu"
         Driver "amdgpu"
         Option "VariableRefresh" "true"
        EndSection
      '';
    };

    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
