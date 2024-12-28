{ config, lib, pkgs, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.desktop.xmonad;
in
{
  options.desktop.xmonad = {
    enable = mkEnableOption "xmonad config";
    users = mkOption {
      description = "List of users that use desktop configuration";
      type = with types; listOf str;
    };
  };

  config = mkIf config.desktop.xmonad.enable {
    assertions = desktop.mkDesktopAssertion config cfg.users;

    services.xserver = {
      enable = true;
      windowManager.session = [{
        name = "xmonad";
        start = ''
          systemd-cat -t xmonad -- ${config.home-manager.users.wittano.xsession.windowManager.command} &
          waitPID=$!
        '';
      }];
    };

    home-manager.users = desktop.mkMultiUserHomeManager cfg.users {
      programs.xmobar = {
        enable = true;
        package = unstable.xmobar;
        extraConfig = builtins.readFile ./xmobarrc;
      };

      xsession.windowManager.xmonad = {
        inherit (unstable) haskellPackages;

        enable = true;
        enableContribAndExtras = true;
        config = ./src/Main.hs;
        libFiles = trivial.pipe ./src [
          builtins.readDir
          (attrsets.filterAttrs (n: v: !(strings.hasPrefix "Main" n)))
          (builtins.mapAttrs (n: v: pkgs.writeText n (builtins.readFile (./src + "/${n}"))))
        ];
      };
    };
  };
}
