{ config, pkgs, lib, modulesPath, systemStaff, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.virtualization;
  virutalizationDir = mapper.mapDirToAttrs ./virtualization;
in
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  options = {
    modules.hardware.virtualization = {
      enable = mkEnableOption ''
        Enable virutalization tools
      '';

      enableDocker = mkEnableOption ''
        Enable Docker
      '';

      enableWindowsVM = mkEnableOption ''
        Enable Windows Gaming VM
      '';

      enableVagrant = mkEnableOption ''
        Enable Vagrant tool for virtualization
      '';
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker.enable = cfg.enableDocker;
      virtualbox.host.enable = cfg.enableVagrant;
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu = {
          package = unstable.qemu;
          ovmf.enable = true;
          runAsRoot = true;
        };
      };
    };

    users.users.wittano.extraGroups = [
      (mkIf cfg.enableDocker "docker")
      (mkIf cfg.enableVagrant "vboxusers")
      "libvirtd"
    ];

    services.xserver.displayManager.session = mkIf cfg.enableWindowsVM [{
      name = "windows";
      manage = "window";
      start = "sudo virsh start win10";
    }];

    security.sudo.extraRules = mkIf cfg.enableWindowsVM [{
      users = [ "wittano" ];
      commands = [{
        command = "${pkgs.libvirt}/bin/virsh start win10";
        options = [ "NOPASSWD" ];
      }];
    }];

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [ libguestfs ] ++ (lists.optionals cfg.enableVagrant [ vagrant ]);

    systemd.services.libvirtd = mkIf cfg.enableWindowsVM {
      path =
        let
          env = pkgs.buildEnv {
            name = "qemu-hook-env";
            paths = with pkgs; [ bash libvirt kmod systemd ripgrep sd ];
          };
        in
        [ env ];

      preStart =
        let
          stopBoincScript = pkgs.writeScript "stop-boinc.sh" ''
            #!/usr/bin/env bash

            systemctl stop display-manager.service
            systemctl stop boinc.service
          '';
          startBoincScript = pkgs.writeScript "start-boinc.sh" ''
            #!/usr/bin/env bash

            systemctl start boinc.service
          '';
        in
        mkIf (cfg.enableWindowsVM) ''
          mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin
          mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/release/end
          mkdir -p /var/lib/libvirt/vbios

          ln -sf ${virutalizationDir.hooks.qemu.source} /var/lib/libvirt/hooks/qemu

          ln -sf ${
            virutalizationDir.hooks."qemu.d".win10.prepare.begin."start.sh".source
          } /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
          ln -sf ${
            virutalizationDir.hooks."qemu.d".win10.release.end."revert.sh".source
          } /var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh

          ln -sf ${stopBoincScript} /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/boinc.sh
          ln -sf ${startBoincScript} /var/lib/libvirt/hooks/qemu.d/win10/release/end/boinc.sh

          ln -sf ${
            virutalizationDir."vibios.rom".source
          } /var/lib/libvirt/vbios/vibios.rom
        '';
    };

    systemd.services.pcscd.enable = !cfg.enableWindowsVM;
    systemd.sockets.pcscd.enable = !cfg.enableWindowsVM;

    home-manager.users.wittano.programs.fish.shellAliases =
      mkIf (cfg.enableWindowsVM && config.modules.shell.fish.enable) {
        vm = "bash ${virutalizationDir."select-vagrant-vm.sh".source}";
      };

    boot = {
      kernelPackages = mkIf cfg.enableWindowsVM pkgs.linuxPackages_5_15; # TODO Check if linux kernel 6.X.X fixed problem with black screen after shutdown gaming VM
      kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      kernelModules = [ "kvm-intel" "vifo-pci" ];
    };
  };
}
