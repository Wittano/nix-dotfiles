{ config, pkgs, lib, modulesPath, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.virtualization.wittano;

  vmNames = trivial.pipe cfg.stopServices [
    (builtins.map (x: x.name))
    lists.unique
  ];

  isAutoscriptEnable = lists.any
    (x: home-manager.users.${x}.desktop.autostart.enable or false)
    (desktop.getNormalUsers config);

  mkQemuHook = vm: scripts:
    let
      installQemuScript = strings.optionalString cfg.enableWindowsVM ''
        mkdir -p $out/release/end

        cp start.sh $out/prepare/begin/start.sh
        cp revert.sh $out/release/end/revert.sh
      '';

      name = "${vm}-stop-services";
      scriptFile = pkgs.writeShellScript name (builtins.concatStringsSep "\n" scripts);

    in
    pkgs.stdenv.mkDerivation {
      inherit name;

      src = ./.;

      installPhase = ''
        mkdir -p $out/prepare/begin
        cp ${scriptFile} $out/prepare/begin/${name}.sh
      '' + installQemuScript;
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

  qemuHooks = builtins.listToAttrs
    (builtins.map
      (name:
        {
          inherit name;
          value = trivial.pipe cfg.stopServices [
            (builtins.filter (x: x.name == name))
            (builtins.map (x: x.services or [ ]))
            lists.flatten
            lists.unique
            (builtins.map (x: "systemctl stop ${x} || true"))
            (mkQemuHook name)
          ];
        })
      vmNames);
in
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  options = {
    hardware.virtualization.wittano = {
      enable = mkEnableOption "Enable virutalization tools";
      enableWindowsVM = mkEnableOption "Enable Windows Gaming VM";
      users = mkOption {
        type = with types; listOf str;
        description = "List of users who will be added virt libvirtd";
      };
      stopServices = mkOption {
        description = "Set of services, that should be stopped by KVM before start VM";
        type = with types; listOf (submodule {
          options = {
            name = mkOption {
              type = str;
              description = "VM name, which should be stop service";
            };
            services = mkOption {
              type = listOf str;
              description = "List of services, that should be stopped";
              default = [ ];
            };
          };
        });
        default = [{
          name = "win10";
          services = [ ];
        }];
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
            package = unstable.qemu;
            ovmf.enable = true;
            runAsRoot = true;
          };
          hooks.qemu = mkIf cfg.enableWindowsVM qemuHooks;
        };
      };

      warnings = mkIf cfg.enableWindowsVM [ "Windows 10 VM will DISABLE all swap devices in configuration" ];

      swapDevices = mkIf cfg.enableWindowsVM (mkForce [ ]);

      security.sudo.extraRules = mkIf cfg.enableWindowsVM [{
        inherit (cfg) users;

        commands = [{
          command = "/run/current-system/sw/bin/virsh";
          options = [ "NOPASSWD" ];
        }];
      }];

      users.users = trivial.pipe cfg.users [
        (builtins.map (x: {
          name = x;
          value = {
            extraGroups = [ "libvirtd" ];
          };
        }))
        builtins.listToAttrs
      ];

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

      system.activationScripts.installWindowsVMFiles = link.mkLinks [
        {
          src = ./amd.vibios.rom;
          dest = "/var/lib/libvirt/vbios/amd.vibios.rom";
          active = cfg.enableWindowsVM;
        }
        {
          src = ./qemu;
          dest = "/var/lib/libvirt/hooks/qemu";
          active = cfg.enableWindowsVM;
        }
      ];

      boot = mkIf cfg.enableWindowsVM {
        kernelParams = [ "amd_iommu=on" "iommu=pt" "iommu=1" ];
        kernelModules = [ "vifo-pci" "vendor-reset" ];
        extraModulePackages = with config.boot.kernelPackages; [ vendor-reset ];
      };

      services = {
        ssh.wittano.enable = true;
        xserver.displayManager.session = mkIf (cfg.enableWindowsVM && isAutoscriptEnable) [{
          name = "windows";
          manage = "window";
          start = "sudo virsh start win10";
        }];

        udev = {
          packages = with config.boot.kernelPackages; [ vendor-reset ];
          extraRules = mkIf cfg.enableWindowsVM ''
            ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${pkgs.bash}/bin/bash -c '${meta.getExe usbMountScript} ''$attr{idProduct} ''$attr{idVendor}'"
            ACTION=="remove", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="${meta.getExe unmountScript}"
          '';
        };
      };
    };
}

