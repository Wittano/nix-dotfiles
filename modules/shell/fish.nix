{ config, lib, pkgs, home-manager, hostName, username, ... }:
with lib;
let cfg = config.modules.shell.fish;
in {

  options = {
    modules.shell.fish = {
      enable = mkEnableOption ''
        Enable fish shell
      '';

      default = mkEnableOption ''
        Enable fish shell as default shell for main user
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users."${username}".shell = mkIf cfg.default pkgs.fish;

    environment.shells = mkIf cfg.default (with pkgs; [ fish ]);

    home-manager.users.wittano.programs.fish = {
      enable = true;
      shellAliases = let
        host = builtins.replaceStrings [ "-dev" ] [ "" ] hostName;
        rebuild = name:
          "sudo nixos-rebuild switch --flake ${config.environment.variables.NIX_DOTFILES}#${name}";
      in { # TODO Replace classic usages command by nix absolute path
        boinc = "sudo boincmgr -d /var/lib/boinc";
        ra = "ranger";
        xc = "xprop | grep _OB_APP_CLASS";
        yta = ''
          youtube-dl -x --audio-format mp3 -o "%(title)s.%(ext)s" --prefer-ffmpeg''; # FIXME Add condition on exisitng youtube-dl package
        re = rebuild host;
        dev = rebuild "${host}-dev";
        vm = "bash $HOME/projects/config/system/scripts/select-vagrant-vm.sh";
        neofetch = "nix-shell -p neofetch --run 'neofetch'";
      };

        # TODO Added more plugins installed by default
      plugins = [{
        name = "dracula-theme";
        src = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "fish";
          rev = "28db361b55bb49dbfd7a679ebec9140be8c2d593";
          sha256 = "07kz44ln75n4r04wyks1838nhmhr7jqmsc1rh7am7glq9ja9inmx";
        };
      }];
    };
  };
}
