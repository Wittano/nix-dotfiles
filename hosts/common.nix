{ lib
, pkgs
, inputs
, unstable
, master
, hostname
, secretDir ? ./../secrets/homelab.crt
, desktopName ? "xmonad"
, cores ? 24
, ...
}:
with lib;
with lib.my;
let
  accent = "pink";
  flavor = "latte";

  systemVersion = "25.05";

  networkModule = import (./. + "/${hostname}/networking.nix") { inherit lib; };
  hardwareModule = import (./. + "/${hostname}/hardware.nix") { };
in
mkMerge [
  networkModule
  hardwareModule
  rec {

    # Nix configuration
    nix = {
      settings = rec {
        inherit cores;

        max-jobs = cores;
        auto-optimise-store = true;
      };
      extraOptions = "experimental-features = nix-command flakes pipe-operators";
    };

    nixpkgs.config = {
      allowBroken = false;
      allowUnfree = true;
    };

    time.timeZone = "Europe/Warsaw";

    # Locale
    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };
    };

    console = {
      font = "Lat2-Terminus16";
      keyMap = services.xserver.xkb.layout;
    };

    # Fonts
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-extra
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji-blob-bin

      hanazono
      hackgen-nf-font
    ];

    # Global packages
    environment = {
      systemPackages = with pkgs; [ vim htop bash ];
      variables =
        {
          EDITOR = "vim";
          NIX_DOTFILES = "$HOME/nix-dotfiles";
        };

      shells = with pkgs; [ bash fish ];
    };

    # Linux Kernel settings
    boot = {
      tmp.cleanOnBoot = true;
      supportedFilesystems = {
        ntfs = true;
        nfs = true;
      };
      initrd.availableKernelModules = [ "ahci" "xhci_pci" "sd_mod" "sr_mod" ];
      loader = {
        grub.wittano = {
          enable = true;
          enableMultiBoot = false;
        };
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
      };

      plymouth = {
        enable = true;
        themePackages = with pkgs; [ nixos-blur-playmouth ];
        theme = "nixos-blur";
      };
    };

    hardware = {
      trackpoint.emulateWheel = true;
      printers.wittano.enable = true;
      bluetooth.wittano.enable = true;
    };

    # Network
    networking = {
      hostName = "nixos";
      firewall = {
        allowPing = false;
        rejectPackets = true;
      };
    };

    #User settings
    users.users.wittano = {
      isNormalUser = true;
      uid = mkDefault 1000;
      shell = pkgs.fish;
    };

    catppuccin = {
      inherit accent flavor;

      enable = mkForce false;
    };

    programs = {
      nh.wittano.enable = true;
      krusader.enable = true;
      fish.enable = true;
      file-roller.enable = true; # Archive explorer
      evince.enable = true; # PDF viever
      droidcam.enable = false; # FIXME Problem with sharing Video phone <-> pc. ONLY ON LINUX
    };

    # Home-manager
    home-manager = {
      extraSpecialArgs = { inherit pkgs unstable lib inputs master; };
      useUserPackages = true;
      backupFileExtension = "backup";
    };


    desktop."${desktopName}".enable = true;

    # System
    system.stateVersion = systemVersion;

    services = {
      backup.enable = true;
      pipewire.wittano.enable = true;
      udisks2 = {
        enable = true;
        mountOnMedia = true;
      };

      devmon.enable = true;
      gvfs.enable = true;
      xserver = {
        xkb.layout = "pl";
        wacom.wittano.enable = true;
      };

      syncthing.wittano.enable = true;
      displayManager.sddm.wittano = {
        enable = true;
        package = pkgs.catppuccin-sddm-corners;
      };
    };

    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };


    security.pki.certificateFiles = [
      "${secretDir}/homelab_ca.pem"
    ];
  }
]
