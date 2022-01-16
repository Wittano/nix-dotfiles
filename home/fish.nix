{ config, pkgs ? <nixpkgs>, ... }:
let
  wacomScript = "$HOME/dotfiles/scripts/wacom-multi-monitor.sh";
in {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      gst = "git status";
      gc = "git commit";
      "gc!" = "git commit --amend";
      gaa = "git add .";
      ggpush = "git push";
      ggpull = "git pull";
      boinc = "sudo boincmgr -d /var/lib/boinc";
      wacom = "bash ${wacomScript}";
      ra = "ranger";
      xc = "xprop | grep _OB_APP_CLASS";
      yta = ''youtube-dl -x --audio-format mp3 -o "%(title)s.%(ext)s" --prefer-ffmpeg'';
      re = "sudo nixos-rebuild switch";
      neofetch = "nix-shell -p neofetch --run 'neofetch'";
    };

    loginShellInit = ''
      bash ${wacomScript};
    '';

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
}
