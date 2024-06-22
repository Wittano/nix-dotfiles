{ config, pkgs, lib, modulesPath, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.virtualization;
  virutalizationDir = mapper.mapDirToAttrs ./virtualization;

  virshPath = "${config.virtualisation.libvirtd.package}/bin/virsh";
in
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  options = {
    modules.hardware.virtualization = {
      enable = mkEnableOption "Enable virutalization tools";
      enableWindowsVM = mkEnableOption "Enable Windows Gaming VM";
    };
  };

  config = mkIf cfg.enable {
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
        hooks.qemu.win10 = mkIf (cfg.enableWindowsVM) ./virtualization/hooks/win10;
      };
    };

    users.users.wittano.extraGroups = [ "libvirtd" ];

    services.xserver.displayManager.session = mkIf cfg.enableWindowsVM [{
      name = "windows";
      manage = "window";
      start = "virsh start win10";
    }];

    security.sudo.extraRules = mkIf cfg.enableWindowsVM [{
      users = [ "wittano" ];
      commands = [{
        command = "${virshPath} start win10";
        options = [ "NOPASSWD" ];
      }];
    }];

    programs = {
      virt-manager.enable = true;
      dconf.enable = true;
    };

    environment.systemPackages = with pkgs; [ libguestfs ];

    systemd = {
      services = {
        libvirtd = mkIf cfg.enableWindowsVM {
          path =
            let
              env = pkgs.buildEnv {
                name = "qemu-hook-env";
                paths = with pkgs; [ bash libvirt kmod systemd ripgrep sd ];
              };
            in
            [ env ];

          preStart = mkIf (cfg.enableWindowsVM) ''
            mkdir -p /var/lib/libvirt/vbios

            ln -sf ${virutalizationDir."vibios.rom".source} /var/lib/libvirt/vbios/vibios.rom
          '';
        };

        pcscd.enable = mkIf cfg.enableWindowsVM false;
      };
      
      sockets.pcscd.enable = mkIf cfg.enableWindowsVM false;
    };

    boot = {
      kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      kernelModules = [ "kvm-intel" "vifo-pci" ];
    };
  };
}
