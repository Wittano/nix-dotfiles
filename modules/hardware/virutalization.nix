{ config, pkgs, lib, modulesPath, ... }:
with lib;
let cfg = config.modules.hardware.virtualization;
in {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  options = {
    modules.hardware.virtualization = {
      enable = mkEnableOption ''
        Enable virutalization tools
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

    users.users.wittano.extraGroups =
      [ (mkIf cfg.enableDocker "docker") "libvirtd" ];

    environment.systemPackages = with pkgs; [ virt-manager ];

    boot.kernelModules = [ "kvm-intel" ];
  };
}