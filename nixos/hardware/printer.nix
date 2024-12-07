{ config, pkgs, lib, ... }:
with lib;
{
  options.hardware.printers.wittano.enable = mkEnableOption "Enable CUPS services and install printer driver";

  config = mkIf config.hardware.printers.wittano.enable {
    # Scanner
    hardware.sane = {
      enable = true;
      brscan4.enable = true;
    };
    users.users.wittano.extraGroups = [ "scanner" "lp" ];
    environment.systemPackages = with pkgs; [ simple-scan ];

    # Printer
    hardware.printers = rec{
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
      printing = {
        enable = true;
        drivers = with pkgs; [ brlaser brgenml1lpr brgenml1cupswrapper ];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
      };
    };
  };
}
