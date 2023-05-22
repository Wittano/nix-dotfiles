{ config, pkgs, lib, home-manager, dotfiles, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf types;

  cfg = config.modules.editors.emacs;
  customeActivation = path:
    lib.my.link.createMutableLinkActivation {
      internalPath = path;
      isDevMode = cfg.enableDevMode;
    };
  downloadDoomEmacsScript = ''
    if [ ! -e $HOME/.emacs.d/bin/doom ]; then
      ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
    fi
  '';
in {
  options = {
    modules.editors.emacs = {
      enable = mkEnableOption ''
        Enable Emacs editor
      '';
      enableDevMode = mkEnableOption ''
        Enable Emacs configuration in dev mode
      '';
      version = mkOption {
        type = types.str;
        default = "doom";
        example = "own";
        description = ''
          Choice version of emacs. You have the following avaiable verison of emacs configuration
          - Doom Emacs(doom)
          - My custome emacs configuration(own)
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home = {
        packages =
          mkIf (cfg.version == "doom") (with pkgs; [ git ripgrep coreutils ]);

        activation = {
          linkMutableDoomEmacsConfiguration =
            mkIf (cfg.version == "doom") (customeActivation ".doom.d");
          downloadDoomEmacs = mkIf (cfg.version == "doom")
            (lib.hm.dag.entryAfter [ "writeBoundery" ] downloadDoomEmacsScript);
        };

        file.".doom.d" =
          mkIf (cfg.enableDevMode == false && cfg.version == "doom") {
            source = dotfiles.".doom.d".source;
            onChange = ''
              ${pkgs.systemd}/bin/systemctl --user restart emacs.service
            '';
          };
      };

      programs.emacs.enable = true;
      services.emacs = {
        enable = true;
        defaultEditor = true;
        startWithUserSession = true;
      };
    };
  };
}
