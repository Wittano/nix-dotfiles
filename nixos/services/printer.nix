{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  options.services.printers.wittano = {
    enable = mkEnableOption "Enable CUPS services and install printer driver";
    enableBrother = mkEnableOption "configuration of home Brother DCP-1623WE printer";
  };

  config = mkIf config.services.printers.wittano.enable {
    # Scanner
    hardware.sane = {
      enable = true;
      brscan4.enable = true;
    };
    users.users.wittano.extraGroups = [
      "scanner"
      "lp"
    ];
    environment.systemPackages = with pkgs; [ simple-scan ];

    # Printer
    hardware.printers = mkIf config.services.printers.wittano.enableBrother rec {
      ensureDefaultPrinter = "Brother";
      ensurePrinters = [
        {
          name = ensureDefaultPrinter;
          location = "Home";
          model = "drv:///brlaser.drv/br1600.ppd";
          deviceUri = "usb://Brother/DCP-1610W%20series?serial=E79207E4L151198";
          description = "Brother DCP-1623WE";
        }
      ];
    };
    services = {
      printing = rec {
        enable = config.services.printers.wittano.enable;
        drivers = with pkgs; [
          gutenprint
          brlaser
          brgenml1cupswrapper
          brgenml1lpr
        ];
        webInterface = enable;
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
      };
    };
  };
}
