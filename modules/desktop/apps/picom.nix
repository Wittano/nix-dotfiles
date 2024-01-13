{ pkgs, lib, cfg, dotfiles, ... }:
with lib;
with lib.my; {
  home-manager.users.wittano = {
    home.activation.linkMutablePicomConfig =
      link.createMutableLinkActivation cfg ".config/picom";

    xdg.configFile = let configDir = dotfiles.".config";
    in mkIf (cfg.enableDevMode == false) {
      picom.source = configDir.picom.source;
    };

    systemd.user.services.picom = {
      Unit = {
        Description = ''
          A lightweight compositor for X11 (previously a compton fork)
        '';
        After = "graphical-session.target";
      };
      Service = {
        ExecStart = ''
          ${pkgs.picom-jonaburg}/bin/picom --experimental-backends
        '';
        Restart = "on-failure";
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
  };
}
