{
  lib,
  config,
  pkgs,
  unstable ? pkgs,
  ...
}:
with lib;
with lib.my;
let
  cfg = config.programs.games;

  games = with unstable; [
    # Games
    osu-lazer-bin # osu!lazer
    # airshipper # Veloren
    xivlauncher # FF XIV
    prismlauncher # Minecraft
    # zeroad-unwrapped # 0 A.D
  ];

  fixAge2Sync = pkgs.writeShellApplication {
    name = "fixAge2Sync";
    runtimeInputs = with pkgs; [
      wget
      cabextract
      coreutils
      sudo
    ];
    text = builtins.readFile ./scripts/fixAge2Sync.sh;
    runtimeEnv = {
      STEAM_GAME_DIR = "/mnt/gaming/SteamLibrary";
    };
  };
  fixSteamSystemTray = pkgs.writeScriptBin "fixSteamSystemTray" "rm -rf ~/.local/share/Steam/ubuntu12_32/steam-runtime/pinned_libs_{32,64}";

  patches = [
    fixAge2Sync
    fixSteamSystemTray
  ];
in
{
  options.programs.games = {
    enable = mkEnableOption "Install unrelated(with Steam, lutris or other launchers) games";
    enableDev = mkEnableOption "Enable developer tools to moddling games";
    enableAutostart = mkEnableOption "autostart";
  };

  config = mkIf cfg.enable {
    home.packages = games ++ patches;

    programs = {
      jetbrains.ides = mkIf cfg.enableDev [
        "jvm"
        "dotnet"
      ];
      telegram.enable = true;
      signal.enable = true;
    };

    desktop.autostart.programs = mkIf cfg.enableAutostart [
      "steam -silent"
    ];

    services.picom.wittano.exceptions = games ++ [
      "\.exe$"
      "XIVlauncher.Core"
    ];
  };
}
