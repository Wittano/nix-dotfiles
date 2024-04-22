{ pkgs, lib, dotfiles, ... }:
with lib;
with lib.my; {
  home-manager.users.wittano = {
    home = {
      packages = with pkgs; [ ranger ];

      # It's required cause ranger doesn't allow non-writeable config (27.12.2023)
      activation.copyRangerConfig = hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.coreutils}/bin/cp -r ${dotfiles.ranger.source} /home/wittano/.config

        ${pkgs.coreutils}/bin/chmod -R 755 /home/wittano/.config/ranger
      '';
    };

    programs.fish.shellAliases.ra = "ranger";
  };
}
