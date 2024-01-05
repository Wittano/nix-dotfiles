{ config, pkgs, home-manager, lib, unstable, inputs, ... }:
with lib;
let
  cfg = config.modules.desktop.gaming;
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
    nix.settings = mkIf cfg.enableMihoyoGames inputs.aagl.nixConfig;

    # Genshin Impact
    programs.anime-game-launcher.enable = cfg.enableMihoyoGames;

    # Honkai Railway
    programs.honkers-railway-launcher.enable = cfg.enableMihoyoGames;

    home-manager.users.wittano.home.packages =
      let
        jre = pkgs.jre17_minimal;
        envLibPath = lib.makeLibraryPath (with pkgs;[
          curl
          libpulseaudio
          systemd
          libglvnd
        ]);
        postFixupScript = ''
          # Do not create `GPUCache` in current directory
          makeWrapper $out/opt/minecraft-launcher/minecraft-launcher $out/bin/minecraft-launcher \
            --prefix LD_LIBRARY_PATH : ${envLibPath} \
            --prefix PATH : ${lib.makeBinPath [ jre ]} \
            --set JAVA_HOME ${lib.getBin jre} \
            --chdir /tmp \
            "''${gappsWrapperArgs[@]}"
        '';
        fixedMinecraft = pkgs.minecraft.overrideAttrs { postFixup = postFixupScript; };
      in
      with pkgs; [
        # Lutris
        lutris
        xdelta
        xterm
        gnome.zenity

        # Wine
        bottles
        wineWowPackages.full

        # FSH
        steam-run

        # Minecraft
        fixedMinecraft
      ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

    programs.steam.enable = true;

    # For Genshin Impact
    networking.extraHosts = ''
      0.0.0.0 log-upload-os.mihoyo.com
      0.0.0.0 overseauspider.yuanshen.com
      0.0.0.0 uspider.yuanshen.com
      0.0.0.0 prd-lender.cdp.internal.unity3d.com
      0.0.0.0 thind-prd-knob.data.ie.unity3d.com
      0.0.0.0 thind-gke-usc.prd.data.corp.unity3d.com
      0.0.0.0 cdp.cloud.unity3d.com
      0.0.0.0 remote-config-proxy-prd.uca.cloud.unity3d.com
    '';

    fileSystems = mkIf (cfg.enableAdditionalDisk) {
      "/mnt/gaming" = {
        device = "/dev/disk/by-label/GAMING";
        fsType = "ext4";
      };
    };

    home-manager.users.wittano.programs.fish.shellAliases = mkIf (config.modules.shell.fish.enable) {
      fixSteamSystemTray = "rm -rf ~/.local/share/Steam/ubuntu12_32/steam-runtime/pinned_libs_{32,64}";
    };
  };

}
