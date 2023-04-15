{ config, pkgs, lib, modulesPath, username, systemStaff, ... }:
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
          ovmf.enable = true;
          runAsRoot = true;
        };
      };
    };

    users.users."${username}".extraGroups =
      [
        (mkIf cfg.enableDocker "docker")
        (mkIf cfg.enableVagrant "vboxusers")
        "libvirtd"
      ];

    environment.systemPackages = with pkgs; [ virt-manager dconf libguestfs ]
      ++ (if cfg.enableVagrant then [ vagrant ansible ] else [ ]);

    systemd.services.libvirtd = mkIf cfg.enableWindowsVM {
      path =
        let
          env = pkgs.buildEnv {
            name = "qemu-hook-env";
            paths = with pkgs; [
              bash
              libvirt
              kmod
              systemd
              ripgrep
              sd
            ];
          };
        in
        [ env ];

      # TODO Add script to halt boinc service
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
        ''
          mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin
          mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/release/end
          mkdir -p /var/lib/libvirt/hooks/qemu.d/macOS/prepare/begin
          mkdir -p /var/lib/libvirt/hooks/qemu.d/macOS/release/end
          mkdir -p /var/lib/libvirt/vbios
      
          ln -sf ${systemStaff.vms.win10.hooks.qemu.source} /var/lib/libvirt/hooks/qemu

          ln -sf ${systemStaff.vms.win10.hooks."qemu.d".win10.prepare.begin."start.sh".source} /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
          ln -sf ${systemStaff.vms.win10.hooks."qemu.d".win10.release.end."revert.sh".source} /var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh

          ln -sf ${systemStaff.vms.win10.hooks."qemu.d".win10.prepare.begin."start.sh".source} /var/lib/libvirt/hooks/qemu.d/macOS/prepare/begin/start.sh
          ln -sf ${systemStaff.vms.win10.hooks."qemu.d".win10.release.end."revert.sh".source} /var/lib/libvirt/hooks/qemu.d/macOS/release/end/stop.sh

          ln -sf ${stopBoincScript} /var/lib/libvirt/hooks/qemu.d/macOS/prepare/begin/boinc.sh
          ln -sf ${startBoincScript} /var/lib/libvirt/hooks/qemu.d/macOS/release/end/boinc.sh

          ln -sf ${stopBoincScript} /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/boinc.sh
          ln -sf ${startBoincScript} /var/lib/libvirt/hooks/qemu.d/win10/release/end/boinc.sh

          ln -sf ${systemStaff.vms.win10."vibios.rom".source} /var/lib/libvirt/vbios/vibios.rom
        '';
    };

    systemd.services.pcscd.enable = !cfg.enableWindowsVM;
    systemd.sockets.pcscd.enable = !cfg.enableWindowsVM;

    boot = {
      kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      kernelModules = [ "kvm-intel" "vifo-pci" ];
    };
  };
}
