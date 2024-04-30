{ pkgs, lib, config, hostname, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.autoUpgrade;
  workingDirectory = config.environment.variables.NIX_DOTFILES;
  impureFlag = optionalString config.modules.services.syncthing.enable "--impure";
in
{
  # TODO Check if nixos autoupgrade service works for my purposes
  options = {
    modules.services.autoUpgrade = {
      enable = mkEnableOption "Enable autoUpgrade service";
      enableDefault = mkEnableOption "Enable default autoUpgrade service from NixOS";
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.enable && cfg.enableDefault);
        message = "AutoUpgrade service can be activated by one of option: enable or enableDefault. Not both";
      }
    ];

    # Default autoUpgrade service
    system.autoUpgrade = mkIf (cfg.enableDefault) {
      enable = cfg.enableDefault;
      flake = "github:wittano/nix-dotfiles";
    };

    home-manager.users.wittano.home.activation = mkIf (cfg.enable) {
      downloadNixDotfilesRepo = hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ -d /home/wittano/.ssh ]; then
          NIX_DOTFILES_REPO="git@github.com:Wittano/nix-dotfiles.git"
        else
          NIX_DOTFILES_REPO="https://github.com/Wittano/nix-dotfiles.git"
        fi

        if [ ! -d $NIX_DOTFILES ]; then
          ${pkgs.git}/bin/git clone $NIX_DOTFILES_REPO $NIX_DOTFILES
        fi
      '';
    };

    systemd.services.autoUpgrade = mkIf (cfg.enable) {
      after = [ "network.target" ];
      description = "Update nix-dotfiles repo and sytem";
      path = with pkgs; [ git nixFlakes libnotify su nixos-rebuild ];
      script = /*bash*/ ''
        #!/usr/bin/env bash
        su -c "git pull --rebase origin main" wittano || echo "Something went wrong, but it's ok"

        nix flake update

        nixos-rebuild switch --flake .#${hostname} ${impureFlag} || echo "Failed to upgrade system"
      '';
      serviceConfig.WorkingDirectory = workingDirectory;
    };

    systemd.timers.autoUpgrade = mkIf (cfg.enable) rec {
      description = "Update nix-dotfiles repo and sytem";
      requiredBy = [ timerConfig.Unit ];
      timerConfig = {
        OnBootSec = "5min";
        Unit = "autoUpgrade.service";
      };
    };
  };
}

