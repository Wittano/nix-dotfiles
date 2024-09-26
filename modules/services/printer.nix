{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.printer;

  configDir = "/etc/scanbd";
  saneConfigDir = "${configDir}/sane.d";

  scanbdConf = pkgs.writeText "scanbd.conf"
    ''
      global {
        debug = true
        debug-level = 3
        user = wittano
        group = scanner
        scriptdir = ${configDir}/scripts
        pidfile = /var/run/scanbd.pid
        timeout = 500
        environment {
          device = "SCANBD_DEVICE"
          action = "SCANBD_ACTION"
        }

        multiple_actions = true
        action scan {
          filter = "^scan.*"
          numerical-trigger {
            from-value = 1
            to-value = 0
          }
          desc = "Scan to file"
          script = "scan.script"
        }
      }
    '';

  scanScript = pkgs.writeShellApplication
    {
      name = "scanbd_scan";
      runtimeInputs = with pkgs; [ coreutils sane-frontends sane-backends ghostscript imagemagick ];
      text = ''
        date="$(date --iso-8601=seconds)"
        filename="Scan $date.pdf"
        tmpdir="$(mktemp -d)"
        pushd "$tmpdir"
        scanadf -d "$SCANBD_DEVICE" --source "ADF Duplex" --mode Gray --resolution 200dpi

        # Convert any PNM images produced by the scan into a PDF with the date as a name
        convert image* -density 200 "$filename"
        chmod 0666 "$filename"

        # Remove temporary PNM images
        rm --verbose image*

        # Atomic move converted PDF to destination directory
        paperlessdir="/var/lib/paperless/consume"
        cp -pv "$filename" $paperlessdir/"$filename".tmp &&
        mv $paperlessdir/"$filename".tmp $paperlessdir/"$filename" &&
        rm "$filename"

        popd
        rm -r "$tmpdir"
      '';
    };
in
{
  options = {
    modules.services.printer = {
      enable = mkEnableOption "Enable CUPS services and install printer driver";
    };
  };

  imports = [
    <nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
  ];

  config = mkIf cfg.enable {
    # Scanner
    hardware.sane = {
      enable = true;
      brscan4.enable = true;
    };
    users.users.wittano.extraGroups = [ "scanner" "lp" ];
    environment.systemPackages = with pkgs; [ gnome.simple-scan ];

    # Printer
    programs.system-config-printer.enable = true;
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
        openFirewall = true;
      };
    };
  };
}
