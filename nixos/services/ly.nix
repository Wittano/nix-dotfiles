{config, pkgs, lib, ...}: with lib; {
  options.services.ly.wittano.enable = mkEnableOption "ly";

  config = mkIf config.services.ly.wittano.enable {
    environment.systemPackages = [pkgs.cmatrix];

    services.displayManager.ly = {
      enable = true;
      settings = {
        allow_empty_password = false;
        animation = "matrix";
        clear_password = true;
        clock = "%R %D";
        show_tty = true;
      };
      x11Support = !config.desktop.labwc.enable;
    };
  };
}
