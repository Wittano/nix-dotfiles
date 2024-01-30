{ config, pkgs, home-manager, lib, inputs, unstable, ... }:
with lib;
let cfg = config.modules.desktop.gaming;
in
{
  options = {
    modules.desktop.gaming = {
      enable = mkEnableOption ''
        Enable games tools
      '';
      enableAdditionalDisk = mkEnableOption ''
        Add special disk to configuration      
      '';
      enableMihoyoGames = mkEnableOption ''
        Install Genshin Impact and Honkai Railway
      '';
    };
  };

  config = mkIf cfg.enable {
    # Genshin Impact
    programs.anime-game-launcher.enable = cfg.enableMihoyoGames;

    # Honkai Railway
    programs.honkers-railway-launcher.enable = cfg.enableMihoyoGames;

    home-manager.users.wittano.home.packages = with pkgs; [
      # Lutris
      lutris
      xdelta
      xterm
      gnome.zenity

      # Wine
      wineWowPackages.full

      # FSH
      steam-run

      # Games
      unstable.prismlauncher # Minecraft launcher
      unstable.xivlauncher # FFXIV launcher
      inputs.nix-gaming.packages.${pkgs.hostPlatform.system}.osu-lazer-bin # osu!lazer
    ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

    programs.steam.enable = true;

    fileSystems = mkIf (cfg.enableAdditionalDisk) {
      "/mnt/gaming" = {
        device = "/dev/disk/by-label/GAMING";
        fsType = "ext4";
      };
    };

    home-manager.users.wittano.programs.fish.shellAliases =
      let

        # TODO Add autodetect compatdata directory for AoE2
        fixAge2SyncScript = pkgs.writeScriptBin "fixAge2Sync.sh" # bash
          ''
            #!/usr/bin/env bash
          
            cd /mnt/gaming/SteamLibrary/steamapps/compatdata/813780/pfx/drive_c/windows/system32

            if [ ! -e "vc_redist.x64.exe" ]; then
                ${pkgs.wget}/bin/wget "https://aka.ms/vs/16/release/vc_redist.x64.exe"
            fi

            sudo ${pkgs.cabextract}/bin/cabextract vc_redist.x64.exe
            sudo ${pkgs.cabextract}/bin/cabextract a10
          '';
      in
      {
        fixSteamSystemTray =
          "rm -rf ~/.local/share/Steam/ubuntu12_32/steam-runtime/pinned_libs_{32,64}";
        fixAge2Sync = "${pkgs.bash}/bin/bash ${fixAge2SyncScript}";
      };
  };

}
