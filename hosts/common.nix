{ config
, lib
, pkgs
, inputs
, unstable
, hostname
, desktopName ? "xmonad"
, cores ? 24
, ...
}:
with lib;
with lib.my;
let
  accent = "peach";
  flavor = "frappe";

  nixDotfilesPath = "${config.home-manager.users.wittano.home.homeDirectory}/nix-dotfiles";

  systemVersion = "24.11";
  homeManagerConfig = {
    imports = [
      inputs.catppuccin.homeManagerModules.catppuccin
      inputs.nixvim.homeManagerModules.nixvim
      ./../home-manager
    ];
    home.stateVersion = systemVersion;

    programs = {
      thunderbird.wittano.enable = true;
      mpv.enable = true;
      btop.enable = true;
      nitrogen.wittano.enable = true;
      kitty.wittano.enable = true;
      fish.wittano = {
        enable = true;
        enableDirenv = true;
      };

      jetbrains.ides = [ "go" "fork" "python" "cpp" "elixir" "haskell" ];
      git.wittano.enable = true;
      rofi.wittano = {
        inherit desktopName;

        enable = true;
      };

      tmux.wittano.enable = true;
      neovim.wittano.enable = true;

      fish = {
        functions.download-yt.body = "${pkgs.parallel}/bin/parallel ${pkgs.yt-dlp}/bin/yt-dlp ::: $argv";
        shellAliases = {
          open = "xdg-open";

          # Projects
          pnix = "cd $HOME/nix-dotfiles";
          plab = "cd $HOME/projects/server/home-lab";

          # Nix
          nfu = "nix flake update";
          nfc = "nix flake check";
          repl = "nix repl -f '<nixpkgs>'";

          # systemd
          scs = "sudo systemctl status";
          scst = "sudo systemctl stop";
          scsta = "sudo systemctl start";
          sce = "sudo systemctl enable --now";
          scr = "sudo systemctl restart";
          sdb = "systemd-analyze blame";
        };
      };
    };

    qt.wittano.enable = true;
    gtk.wittano.enable = true;

    catppuccin = {
      inherit accent flavor;

      enable = true;
    };

    services = {
      redshift.wittano.enable = true;
      picom.wittano.enable = true;
      dunst.wittano.enable = true;
    };

    home.packages = with pkgs; [
      # Utils
      flameshot

      # Folder Dialog menu
      zenity

      # Web browser
      vivaldi

      # Utils 
      eog # Image viewer
      onlyoffice-bin # Office staff
      nemo
      sshs
      pandoc # Text file converter

      # Apps
      spotify
      logseq
      keepassxc
      krita
      qbittorrent
      # vlc
      # unstable.joplin-desktop # Notebook
      # unstable.vscodium # VS code
      minder # Mind maps
      # insomnia # REST API Client
      gnome-pomodoro
      # unstable.figma-linux # Figma
      todoist-electron # ToDo app

      # Security
      bitwarden

      # Social media
      telegram-desktop
      # unstable.freetube # Youtube desktop
      signal-desktop # Signal desktop
      element-desktop # matrix communicator
      vesktop
      irssi # IRC chat
      # unstable.streamlink-twitch-gui-bin
    ];

    desktop.autostart.enable = true;

    gtk.gtk3.bookmarks = [
      "file://${nixDotfilesPath} Nix configuration"
    ];
  };

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
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      package = pkgs.nix;
      extraOptions = "experimental-features = nix-command flakes";
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
      systemPackages = with pkgs; [ vim htop bash keymapp wally-cli ];
      variables =
        {
          EDITOR = "vim";
          NIX_DOTFILES = nixDotfilesPath;
        };

      shells = with pkgs; [ bash fish ];
    };

    # Linux Kernel settings
    boot = {
      supportedFilesystems = {
        ntfs = true;
        nfs = true;
      };
      initrd.availableKernelModules = [ "ahci" "xhci_pci" "sd_mod" "sr_mod" ];

      tmp.cleanOnBoot = true;

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

    virtualisation.docker.wittano.enable = true;
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
    users.users = {
      wittano = {
        isNormalUser = true;
        uid = mkDefault 1000;
        extraGroups = [ "wheel" ];
        shell = pkgs.fish;
      };
    };

    catppuccin = {
      inherit accent flavor;

      enable = mkForce false;
    };

    programs = {
      fish.enable = true;
      file-roller.enable = true; # Archive explorer
      evince.enable = true; # PDF viever
      # droidcam.enable = true; # FIXME Problem with sharing Video phone <-> pc. ONLY ON LINUX
    };

    # Home-manager
    home-manager = {
      extraSpecialArgs = { inherit pkgs unstable lib inputs; };
      useUserPackages = true;
      backupFileExtension = "backup";
      users.wittano = homeManagerConfig;
    };

    # Programs
    services.locate = {
      enable = true;
      interval = "21:37";
    };

    desktop."${desktopName}" = {
      enable = true;
      users = [ "wittano" ];
    };

    # System
    system.stateVersion = systemVersion;

    services = {
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
  }
]
