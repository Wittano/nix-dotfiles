{ config, pkgs ? <nixpkgs>, ... }: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      gst = "git status";
      gc = "git commit";
      gcc = "git commit --amend";
      gpush = "git push";
      gpull = "git pull";
      boinc-gui = "sudo boincmgr -d /var/lib/boinc";
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
}
