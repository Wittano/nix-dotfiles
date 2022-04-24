{ config, lib, pkgs, home-manager, hostName, ... }:
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
    users.users.wittano.shell = mkIf cfg.default pkgs.fish;

    environment.shells = mkIf cfg.default (with pkgs; [ fish ]);

    home-manager.users.wittano.programs.fish = {
      enable = true;
      shellAbbrs =
        let
          rebuild = name: "sudo nixos-rebuild switch --flake '$NIX_DOTFILES#${name}'";
        in {
          boinc = "sudo boincmgr -d /var/lib/boinc";
          ra = "ranger";
          xc = "xprop | grep _OB_APP_CLASS";
          yta = ''youtube-dl -x --audio-format mp3 -o "%(title)s.%(ext)s" --prefer-ffmpeg'';
          re = rebuild hostName;
          dev = rebuild "${hostName}-dev";
          vm = "bash $HOME/projects/config/system/scripts/select-vagrant-vm.sh";
          neofetch = "nix-shell -p neofetch --run 'neofetch'";
        };

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
