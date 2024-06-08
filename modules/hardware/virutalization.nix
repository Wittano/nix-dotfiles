{ config, pkgs, lib, modulesPath, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.virtualization;
  virutalizationDir = mapper.mapDirToAttrs ./virtualization;
  homeDir = config.home-manager.users.wittano.home.homeDirectory;

  virshPath = "${config.virtualisation.libvirtd.package}/bin/virsh";
in
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  options = {
    modules.hardware.virtualization = {
      enable = mkEnableOption "Enable virutalization tools";
      enableWindowsVM = mkEnableOption "Enable Windows Gaming VM";
      enableVagrant = mkEnableOption "Enable Vagrant tool for virtualization";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
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
        hooks.qemu.win10 = mkIf (cfg.enableWindowsVM) ./virtualization/hooks/win10;
      };
    };

    users.users.wittano.extraGroups = [
      (mkIf cfg.enableVagrant "vboxusers")
      "libvirtd"
    ];

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

      preStart = mkIf (cfg.enableWindowsVM) ''
        mkdir -p /var/lib/libvirt/vbios

        ln -sf ${virutalizationDir."vibios.rom".source} /var/lib/libvirt/vbios/vibios.rom
      '';
    };

    systemd.services.pcscd.enable = !cfg.enableWindowsVM;
    systemd.sockets.pcscd.enable = !cfg.enableWindowsVM;

    modules.shell.fish.completions = mkIf (cfg.enableVagrant) {
      "vm" = ''
        function __fish_vm_list
          find ${homedir}/projects/config/system -name Vagrantfile -type f | cut -d '/' -f 8
        end

        set -l vagrant_commands destroy start halt up ssh reload restart

        for vm in (__fish_vm_list)
          complete -f -c vm -n "not __fish_seen_subcommand_from (__fish_vm_list)" -a $vm
          complete -f -c vm -n "__fish_seen_subcommand_from $vm; and not __fish_seen_subcommand_from $vagrant_commands" -a "$vagrant_commands"
        end

        complete -f -c vm -n "not __fish_seen_subcommand_from all" -a all
        complete -f -c vm -n "__fish_seen_subcommand_from all; and not __fish_seen_subcommand_from $vagrant_commands" -a "$vagrant_commands"
      '';
    };

    home-manager.users.wittano = mkIf (cfg.enableVagrant) {
      programs.fish.shellAliases.vm = "bash ${virutalizationDir."select-vagrant-vm.sh".source}";
    };

    boot = {
      kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      kernelModules = [ "kvm-intel" "vifo-pci" ];
    };
  };
}
