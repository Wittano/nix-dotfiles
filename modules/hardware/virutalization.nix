{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.hardware.virutalization;
in {
  options = {
    modules.hardware.virtualization = {
      enable = mkEnableOption ''
        Enable virutalization tootls
      '';

      enableDocker = mkEnableOption ''
        Enable Docker
      '';
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker.enable = cfg.enableDocker;
      libvirtd.enable = true;
    };

    users.users.wittano.extraGroups = [ "docker" "libvirtd" ];

    environment.systemPackages = with pkgs; [ virt-manager ];

    boot.kernelModules = [ "kvm-intel" ];
  };
}
