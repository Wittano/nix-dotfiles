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

    programs.fish.enable = cfg.enable;

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
          linkMutableExternalAliasesConfig =
            customeActivation ".config/fish/conf.d";
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
            xc = "xprop | grep CLASS";
            yta = ''nix run nixpkgs#youtube-dl -- -x --audio-format mp3 -o "%(title)s.%(ext)s" --prefer-ffmpeg'';
            re = rebuild host;
            dev = rebuild "${host}-dev";

            # Programs
            neofetch = "nix run nixpkgs#neofetch";
            btop = "nix run nixpkgs#btop";
            onefetch = "nix run nixpkgs#onefetch";
            py = "nix run nixpkgs#python3";

            # Projects
            pnix = "cd $NIX_DOTFILES";
            prepo = "cd $HOME/projects/config/nix-repo";
            pdot = "cd $DOTFILES";
          };
      };
    };
  };
}
