{ config, pkgs, lib, dotfiles, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.editors.emacs;
  homeDir = config.home-manager.users.wittano.home.homeDirectory;
  
  downloadDoomEmacsScript = ''
    if [ ! -e ${homeDir}/.emacs.d/bin/doom ]; then
      ${pkgs.git}/bin/git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
    fi
  '';
in
{
  options = {
    modules.editors.emacs = {
      enable = mkEnableOption "Enable Emacs editor";
      enableDevMode = mkEnableOption "Enable Emacs configuration in dev mode";
      version = mkOption {
        type = types.enum [ "doom" "own" ];
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
          linkMutableDoomEmacsConfiguration = mkIf (cfg.version == "doom")
            (link.createMutableLinkActivation cfg ".doom.d");
          downloadDoomEmacs = mkIf (cfg.version == "doom")
            (hm.dag.entryAfter [ "writeBoundery" ] downloadDoomEmacsScript);
        };

        file.".doom.d" =
          mkIf (cfg.enableDevMode == false && cfg.version == "doom") {
            source = dotfiles.".doom.d".source;
            onChange = "${pkgs.systemd}/bin/systemctl --user restart emacs.service";
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
