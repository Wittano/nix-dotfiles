# TODO Add catpuccin theme
{ ... }: {
  options = {
    modules.themes.catppuccin = {
      enable = mkEnableOption ''
        Enable catppuccin theme as system theme
      '';
    };
  };

  config = mkIf (cfg.enable) {
    home-manager.users.wittano.gtk = {
      enable = true;
      theme = {
        name = "catppuccin";
        package = pkgs.catppuccin-gtk;
      };
      iconTheme = {
        name = "catppuccin";
        package = pkgs.catppuccin-gtk;
      };
    };
  };
}
