{ config, lib, pkgs, hostname, inputs, unstable, master, secretDir, ... }:
with lib;
with lib.my;
let
  desktopName = "qtile";
  commonConfig = import ../common.nix {
    inherit master config lib hostname pkgs unstable inputs secretDir desktopName;
    cores = 4;
    users = [ "wittano" ];
  };
  commonHomeManager = import ../common-home-manager.nix {
    inherit inputs pkgs master unstable desktopName;
    systemVersion = config.system.stateVersion;
    inherit (config.catppuccin) accent;
    inherit (config.catppuccin) flavor;
  };
in
mkMerge [
  commonConfig
  {
    virtualisation.podman.wittano.enable = true;

    users.users.wittano.extraGroups = [ "wheel" ];

    home-manager.users.wittano = mkMerge [
      commonHomeManager
      {
        home.packages = with pkgs; [ pavucontrol ];

        profile.programming.enable = true;
        programs = {
          jetbrains.ides = [ "go" "cpp" ];
          spotify.enable = true;
        };
        services.betterlockscreen.enable = true;
      }
    ];

    programs.nix-ld.enable = true;
    console.earlySetup = true;

    services.backup.path = "sftp:laptop_backup:/mnt/hdd/backup/laptop";

    hardware = {
      trackpoint.emulateWheel = true;

      samba.enable = true;
      printers.wittano.enable = true;
    };
  }
]
