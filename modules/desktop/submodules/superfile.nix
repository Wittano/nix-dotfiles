{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [ superfile ];

    home-manager.users.wittano.programs.fish.shellAliases.ra = "superfile";
  };
}
