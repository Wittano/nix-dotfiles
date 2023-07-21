{ config, pkgs, lib, home-manager, dotfiles, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.editors.neovim;

  packerDownloadScript = ''
    if [ ! -e $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
        ${pkgs.git}/bin/git clone --depth 1 https://github.com/wbthomason/packer.nvim\
		~/.local/share/nvim/site/pack/packer/start/packer.nvim
	fi
  '';
  customeActivation = path:
    lib.my.link.createMutableLinkActivation {
      internalPath = path;
      isDevMode = cfg.enableDevMode;
    };
in {
  options = {
    modules.editors.neovim = {
      enable = mkEnableOption ''
        Enable Neovim editor
      '';
      enableDevMode = mkEnableOption ''
        Enable Neovim in dev mode
      '';
    };
  };

  # TODO Create full neovim configuration 
  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home = {
	      packages = with pkgs; [ cargo ];

	      activation = {
	        downloadPacker = lib.hm.dag.entryAfter [ "writeBoundery" ] packerDownloadScript;
	        linkNeovimConfiguration = customeActivation ".config/nvim";
	      };
      };

      xdg.configFile = mkIf (cfg.enableDevMode == false) {
        "nvim".source = dotfiles.".config".nvim.source;
      };

      programs = {
        neovim = {
          enable = true;
          extraLuaConfig = ''
            vim.wo.rnu = true
            vim.wo.number = true
          '';
          viAlias = true;
          vimdiffAlias = true;
          withNodeJs = true;
          defaultEditor = true;
        };
      };
    };
  };
}
