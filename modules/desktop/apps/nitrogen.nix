{ pkgs, home-manager, dotfiles, ... }: {
    home-manager.users.wittano = {
        home.packages = with pkgs; [ nitrogen ];
        xdg.configFile.nitrogen.source = dotfiles.".config".nitrogen.source;
    };
}