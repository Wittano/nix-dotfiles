{ config, pkgs, lib, modulesPath, username, ... }:
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
      virtualbox.host.enable = true;
      libvirtd.enable = true;
    };

    users.users."${username}".extraGroups =
      [ (mkIf cfg.enableDocker "docker") "libvirtd" "vboxusers" ];

    environment.systemPackages = with pkgs; [ virt-manager vagrant ansible ];

    services.nfs.server.enable = true;

    boot.kernelModules = [ "kvm-intel" ];
  };
}
