{ config, pkgs, lib, modulesPath, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.virtualization;
  virutalizationDir = mapper.mapDirToAttrs ./virtualization;

  vmNames = trivial.pipe cfg.stopServices [
    (builtins.map (x: x.name))
    lists.unique
  ];

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

      src = ./virtualization;

      installPhase = ''
        mkdir -p $out/prepare/begin
        cp ${scriptFile} $out/prepare/begin/${name}.sh
      '' + installQemuScript;
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
            (builtins.map (x: "systemctl stop ${x} || echo 'Failed disable ${x} service' &"))
            (mkQemuHook name)
          ];
        })
      vmNames);
in
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  options = {
    modules.hardware.virtualization = {
      enable = mkEnableOption "Enable virutalization tools";
      enableWindowsVM = mkEnableOption "Enable Windows Gaming VM";
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
        hooks.qemu = qemuHooks;
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
          src = virutalizationDir.qemu.source;
          dest = "/var/lib/libvirt/hooks/qemu";
          active = cfg.enableWindowsVM;
        };
      in
      vibiosLink + qemuHookScript;

    boot = {
      kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      kernelModules = [ "kvm-intel" "vifo-pci" ];
    };

    services.openssh.openFirewall = mkForce false;
    modules.services.boinc.enable = true;
  };
}
