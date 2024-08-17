{ ... }:
{
  config = {
    home-manager.users.wittano.services.dunst = {
      enable = true;
      catppuccin = {
        enable = true;
        flavor = "macchiato";
      };
    };
  };
}
