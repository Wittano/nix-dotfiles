{ config, pkgs, lib, modulesPath, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.virtualization.wittano;

  mkManageDaemonScript = command: builtins.concatStringsSep
    "\n"
    (builtins.map (x: "systemctl ${command} ${x} || true") cfg.stoppedServices);

  startServices = mkManageDaemonScript "start";
  stopServices = mkManageDaemonScript "stop";

  releaseVmScript = pkgs.writeShellApplication {
    name = "release-vm";
    runtimeInputs = with pkgs; [ bash systemd toybox kmod libvirt ];
    text =
      let
        nvidiaDriver = strings.optionalString config.hardware.nvidia.wittano.enable /*bash*/ ''
          modprobe nvidia
          modprobe nvidia_modeset
          modprobe nvidia_drm
          modprobe nvidia_uvm
        '';

        amdDriver = strings.optionalString config.hardware.amd.enable /*bash*/''
          timeout 10s modprobe amdgpu
        '';
      in
        /*bash*/''
        set -x

        function _reboot() {
            systemctl reboot -i
        }

        trap _reboot ERR

        # Disable VFIO
        modprobe -r vfio_pci

        # Re-Bind GPU to AMD Driver
        timeout 5s virsh nodedev-reattach pci_0000_07_00_0
        timeout 5s virsh nodedev-reattach pci_0000_07_00_1

        # Reload nvidia modules
        ${nvidiaDriver}
        ${amdDriver}

        # Rebind VT consoles
        echo 1 >/sys/class/vtconsole/vtcon0/bind || _reboot
        echo 1 >/sys/class/vtconsole/vtcon1/bind || _reboot

        # Restart Display Manager
        systemctl start display-manager.service
        ${startServices}
      '';
  };

  prepareVmScript = pkgs.writeShellApplication {
    name = "prepare-vm";
    runtimeInputs = with pkgs; [ bash releaseVmScript systemd toybox kmod libvirt ];
    text =
      let
        nvidiaDriver = strings.optionalString config.hardware.nvidia.wittano.enable /*bash*/ ''
          modprobe -r nvidia_uvm
          modprobe -r nvidia_drm
          modprobe -r nvidia_modeset
          modprobe -r nvidia
        '';

        amdDriver = strings.optionalString config.hardware.amd.enable /*bash*/''
          modprobe -r amdgpu
        '';
      in
        /*bash*/ ''
        set -x

        function _revert() {
            release-vm
            exit 1
        }

        trap _revert ERR

        # Stop display manager
        systemctl stop display-manager.service
        ${stopServices}

        while systemctl is-active --quiet "display-manager.service"; do
            sleep 1
        done

        # Unbind VTconsoles
        echo 0 >/sys/class/vtconsole/vtcon0/bind
        echo 0 >/sys/class/vtconsole/vtcon1/bind

        sleep 5

        ${nvidiaDriver}
        ${amdDriver}

        # Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
        sleep 2

        # Unbind the GPU from display driver
        virsh nodedev-detach pci_0000_07_00_0
        virsh nodedev-detach pci_0000_07_00_1

        modprobe vfio_iommu_type1
        modprobe vfio_pci
      '';
  };

  usbMountScript = pkgs.writeShellApplication {
    name = "mount-usb-device";
    runtimeInputs = with pkgs; [ coreutils usbutils toybox libvirt ];
    text = trivial.pipe ./mount-usb.sh [
      builtins.readFile
      (builtins.replaceStrings [ ''vm=""'' ] [ ''vm="win10"'' ])
    ];
  };

  unmountScript = pkgs.writeShellApplication {
    name = "unmount-usb-device";
    runtimeInputs = with pkgs; [ coreutils usbutils toybox libvirt ];
    text = trivial.pipe ./unmount.sh [
      builtins.readFile
      (builtins.replaceStrings [ ''vm=""'' ] [ ''vm="win10"'' ])
    ];
  };


in
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  options = {
    hardware.virtualization.wittano = {
      enable = mkEnableOption "Enable virutalization tools";
      enableWindowsVM = mkEnableOption "Enable Windows Gaming VM";
      stoppedServices = mkOption {
        type = with types; listOf str;
        description = "List of services, that should be stopped";
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable
    {
      virtualisation = {
        spiceUSBRedirection.enable = true;
        libvirtd = {
          enable = true;
          onBoot = "ignore";
          onShutdown = "shutdown";
          qemu = {
            package = mkIf cfg.enableWindowsVM unstable.qemu;
            swtpm.enable = true;
            ovmf = {
              enable = true;
              packages = [
                (pkgs.OVMF.override {
                  secureBoot = true;
                  tpmSupport = true;
                }).fd
              ];
            };
            runAsRoot = true;
          };
          hooks.qemu.win10 = pkgs.stdenvNoCC.mkDerivation {
            name = "win10-hooks";

            src = ./.;

            installPhase = ''
              mkdir -p $out/begin/prepare $out/release/end

              cp ${meta.getExe prepareVmScript} $out/begin/prepare/start.sh
              cp ${meta.getExe releaseVmScript} $out/release/end/stop.sh
            '';
          };
        };
      };

      warnings = mkIf cfg.enableWindowsVM [ "Windows 10 VM will DISABLE all swap devices in configuration" ];

      swapDevices = mkIf cfg.enableWindowsVM (mkForce [ ]);

      security.sudo.extraRules = mkIf cfg.enableWindowsVM [{
        users = [ "wittano" "virt" ];

        commands = [{
          command = "/run/current-system/sw/bin/virsh";
          options = [ "NOPASSWD" ];
        }];
      }];

      users.users =
        let
          virtGroup = [ "libvirtd" ];
        in
        {
          wittano.extraGroups = virtGroup;
          virt = {
            uid = 1002;
            isNormalUser = true;
            extraGroups = virtGroup;
          };
        };
      programs = {
        virt-manager.enable = true;
        dconf.enable = true;
      };

      environment.systemPackages = with pkgs; [ libguestfs virtiofsd ];

      systemd = {
        services = {
          libvirtd.path = mkIf cfg.enableWindowsVM (with pkgs; [ bash libvirt kmod systemd ripgrep sd ]);
          pcscd.enable = mkIf cfg.enableWindowsVM false;
        };

        sockets.pcscd.enable = mkIf cfg.enableWindowsVM false;
      };

      boot = mkIf cfg.enableWindowsVM {
        kernelParams = [ "amd_iommu=on" "preempt=voluntary" ];
        kernelModules = [
          "vendor-reset"
          "kvm-amd"
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
          "vfio_virqfd"
        ];
        extraModulePackages = with config.boot.kernelPackages; [ vendor-reset ];
      };

      services.openssh.settings.AllowUsers = [ "virt" ];

      fileSystems = mkIf cfg.enableWindowsVM {
        "/var/lib/libvirt/images/pool" = {
          device = "/dev/disk/by-label/VM_STORAGE";
          fsType = "ext4";
        };
      };

      services = {
        ssh.wittano.enable = true;
        xserver.displayManager.session = mkIf cfg.enableWindowsVM [{
          name = "windows";
          manage = "window";
          start = "sudo virsh start win10";
        }];

        udev = {
          packages = with config.boot.kernelPackages; [ vendor-reset ];
          extraRules = mkIf cfg.enableWindowsVM ''
            ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${pkgs.bash}/bin/bash -c '${meta.getExe usbMountScript} ''$attr{idProduct} ''$attr{idVendor}'"
            ACTION == "remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${meta.getExe unmountScript}"
          '';
        };
      };
    };
}


