{ config, lib, pkgs, unstable, hostname, ... }:
with lib;
with lib.my;
let
  cfg = config.desktop.xmonad;
  barSuffix = if hostname == "laptop" then "-${hostname}-${config.catppuccin.flavor}" else "-${config.catppuccin.flavor}";
in
{
  options.desktop.xmonad = {
    enable = mkEnableOption "xmonad config";
    users = mkOption {
      description = "List of users that use desktop configuration";
      type = with types; listOf str;
      default = [ "wittano" ];
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

    environment.systemPackages = with pkgs; [ alsa-utils ];

    home-manager.users = desktop.mkMultiUserHomeManager cfg.users {
      programs.xmobar = {
        enable = true;
        package = unstable.xmobar;
        extraConfig = builtins.readFile (./. + "/xmobarrc${barSuffix}");
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
