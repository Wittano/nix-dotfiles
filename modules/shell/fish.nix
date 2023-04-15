{ config, lib, pkgs, home-manager, hostName, username, dotfiles, ... }:
with lib;
with lib.my;
let cfg = config.modules.shell.fish;
in {

  options = {
    modules.shell.fish = {
      enable = mkEnableOption ''
        Enable fish shell
      '';

      enableDevMode = mkEnableOption ''
        Enable fish shell in dev mode
      '';

      default = mkEnableOption ''
        Enable fish shell as default shell for main user
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users."${username}".shell = mkIf cfg.default pkgs.fish;

    environment.shells = mkIf cfg.default (with pkgs; [ fish ]);

    home-manager.users.wittano = {
      home.activation =
        let
          customeActivation = path:
            link.createMutableLinkActivation {
              internalPath = path;
              isDevMode = cfg.enableDevMode;
            };
        in
        {
          linkMutableOmfConfig = customeActivation ".config/omf";
          linkMutableExternalAliasesConfig = customeActivation ".config/fish/conf.d";
        };

      xdg.configFile = mkIf (cfg.enableDevMode == false) {
        omf.source = dotfiles.".config".omf.source;
        "fish/conf.d".source = dotfiles.".config".fish."conf.d".source;
      };

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          direnv hook fish | source
        '';
        loginShellInit = ''
          set -U fish_user_paths $HOME/.local/bin $fish_user_paths
        '';
        shellAliases =
          let
            host = builtins.replaceStrings [ "-dev" ] [ "" ] hostName;
            rebuild = name:
              "sudo nixos-rebuild switch --flake ${config.environment.variables.NIX_DOTFILES}#${name}";
          in
          {
            ra = "ranger";
            xc = "xprop | grep CLASS";
            yta = ''youtube-dl -x --audio-format mp3 -o "%(title)s.%(ext)s" --prefer-ffmpeg'';
            re = rebuild host;
            dev = rebuild "${host}-dev";
            vm = "bash $HOME/projects/config/system/scripts/select-vagrant-vm.sh";
            neofetch = "nix-shell -p neofetch --run 'neofetch'";
          };
      };
    };
  };
}
