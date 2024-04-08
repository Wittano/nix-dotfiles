{ config, lib, pkgs, home-manager, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.gaming;

  fixAge2Sync = unstable.writeShellApplication {
    name = "fixAge2Sync";
    runtimeInputs = with pkgs; [ wget cabextract coreutils sudo ];
    text = builtins.readFile ./scripts/fixAge2Sync.sh;
    runtimeEnv = {
      STEAM_GAME_DIR = cfg.disk.path;
    };
  };
  fixSteamSystemTray = pkgs.writeScriptBin "fixSteamSystemTray"
    "rm -rf ~/.local/share/Steam/ubuntu12_32/steam-runtime/pinned_libs_{32,64}";

  fixMf =
    let
      mfFixRepo = pkgs.fetchFromGitHub {
        repo = "mf-fix";
        owner = "HoodedDeath";
        rev = "e3286c34280e04f62b0519cf47abe6c21b04207a";
        sha256 = "sha256-sgHNTQv7htTYXaCqtoIb5nGMnh72nuph8AXHRfIV/Dc=";
      };
      fixedScript = builtins.replaceStrings [ "python2" ] [ "python" ] (builtins.readFile "${mfFixRepo}/mf-fix.sh");
    in
    pkgs.writeShellApplication {
      name = "mf-fix";
      runtimeInputs = with pkgs; [ python3 coreutils sudo wineWowPackages.full meshoptimizer ];
      excludeShellChecks = [ "SC2181" "SC2034" "SC2199" "SC2086" ];
      text = ''
        cd ${mfFixRepo}

        ${fixedScript}
      '';
    };
in
{

  options.modules.desktop.gaming.scripts = {
    enable = mkEnableOption "Enable custom scripts to fixing or imporved games";
  };

  config = mkIf (cfg.scripts.enable && cfg.enable) {
    home-manager.users.wittano = {
      home.packages = [ fixMf fixAge2Sync fixSteamSystemTray ];
      xdg.configFile = mkIf (config.modules.shell.fish.enable) {
        "fish/completions/mf-fix.fish".text = ''
          complete -c mf-fix -s v -l verbose --no-files
          complete -c mf-fix -s h -l help --no-files
          complete -c mf-fix -s e -l executable -F -r
          complete -c mf-fix -s n -l noconfirm --no-files
        '';
      };
    };
  };

}
