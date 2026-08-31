{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
{
  options.services.teamviewer.wittano = {
    enable = mkEnableOption "teamviewer";
    enableRemoteAccount = mkEnableOption "create system account that allows connect to the machine via TeamViwer";
  };

  config = mkIf config.services.teamviewer.wittano.enable rec {
    services.teamviewer.enable = true;
    environment.systemPackages = with pkgs; [
      teamviewer
    ];

    users.users.guest = {
      enable = config.services.teamviewer.wittano.enableRemoteAccount;
      createHome = true;
      isNormalUser = true;
      uid = mkDefault 1001;
      shell = pkgs.bash;
      initialHashedPassword = "$y$j9T$2XXXHXcP2iIUZAaECc.VC1$VLb8japlHU2PDUSmiYKWhFTJBaVieS7cx1YDzoyMBr4";
    };

    desktop.qtile.users = lists.optionals users.users.guest.enable [ "wittano" "guest" ];

    home-manager.users.guest = mkIf users.users.guest.enable {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
        inputs.nixvim.homeModules.nixvim
        ./../../home-manager
      ];

      home.stateVersion = config.system.stateVersion;

      desktop.autostart.programs = ["teamviewer"];
    };
  };
}
