{ master, ... }:
{
  config = {
    environment.systemPackages = with master; [ superfile ];

    home-manager.users.wittano.programs.fish.shellAliases.ra = "superfile .";
  };
}
