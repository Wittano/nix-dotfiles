{ config, pkgs, lib, modulesPath, unstable, ... }:
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

    programs = {
      virt-manager.enable = true;
      dconf.enable = true;
    };

    environment.systemPackages = with pkgs; [ libguestfs ];

    systemd = {
      services = {
        libvirtd.path = mkIf cfg.enableWindowsVM (with pkgs; [ bash libvirt kmod systemd ripgrep sd ]);
        pcscd.enable = mkIf cfg.enableWindowsVM false;
      };

      sockets.pcscd.enable = mkIf cfg.enableWindowsVM false;
    };

    system.activationScripts.installWindowsVMFiles =
      let
        vibiosLink = link.mkLink {
          src = virutalizationDir."vibios.rom".source;
          dest = "/var/lib/libvirt/vbios/vibios.rom";
          active = cfg.enableWindowsVM;
        };

        qemuHookScript = link.mkLink {
          src = virutalizationDir.hooks.qemu.source;
          dest = "/var/lib/libvirt/hooks/qemu";
          active = cfg.enableWindowsVM;
        };
      in vibiosLink + qemuHookScript;

    boot = {
      kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      kernelModules = [ "kvm-intel" "vifo-pci" ];
    };
  };
}
