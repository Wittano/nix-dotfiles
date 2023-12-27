{ cfg, pkgs, lib, home-manager, dotfiles, ... }:
with lib;
with lib.my;
{
  home-manager.users.wittano = {
    home = {
      packages = with pkgs; [ ranger ];

      # It's required cause ranger doesn't allow non-writeable config (27.12.2023)
      activation.copyRangerConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.coreutils}/bin/cp -r ${dotfiles.".config".ranger.source} /home/wittano/.config

        ${pkgs.coreutils}/bin/chmod -R 755 /home/wittano/.config/ranger
      '';
    };

  };
}
