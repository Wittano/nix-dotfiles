{ config, lib, pkgs, hostname, inputs, unstable, ... }:
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
      ./../../home-manager
    ];
    home.stateVersion = systemVersion;

    programs = {
      btop.enable = true;
      nitrogen.wittano.enable = true;
      kitty.wittano.enable = true;
      fish.wittano = {
        enable = true;
        enableDirenv = true;
      };

      jetbrains.ides = [ "go" "fork" "python" "cpp" "dotnet" ];
      git.wittano.enable = true;
      rofi.wittano = {
        enable = true;
        desktopName = "qtile";
      };

      games.enable = true;
      lutris.enable = true;

      tmux.wittano.enable = true;
      neovim.wittano.enable = true;

      fish.shellAliases = {
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
      home-manager.autoUpgrade = {
        enable = true;
        frequency = "daily";
      };
    };

    home.packages = with pkgs; [
      # Utils
      flameshot

      # Folder Dialog menu
      zenity

      # Web browser
      vivaldi

      # Utils 
      thunderbird # Mail
      eog # Image viewer
      onlyoffice-bin # Office staff
      nemo
      sshs

      # Apps
      spotify
      logseq
      keepassxc
      krita
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

in
rec {

  imports = [ ./hardware.nix ./networking.nix ];

  # Nix configuration
  nix = {
    settings = {
      max-jobs = 24;
      cores = 24;
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
    keyboard.zsa.enable = true;

    virtualization.wittano = {
      enable = false;
      enableWindowsVM = false;
    };
    # nvidia.enable = true;
    amd.enable = true;
    samba.enable = true;
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
    steam.wittano.enable = true;
    mihoyo = {
      enable = true;
      games = [ "honkai-railway" ];
    };
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

  desktop.qtile = {
    enable = true;
    users = [ "wittano" ];
  };

  # System
  system = {
    stateVersion = systemVersion;

    autoUpgrade = {
      enable = false;
      flake = "github:wittano/nix-dotfiles#${hostname}";
      dates = "daily";
    };
  };

  services = {
    prometheus.wittano.enable = false;
    pipewire.wittano.enable = true;
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };

    devmon.enable = true;
    gvfs.enable = true;
    xserver = {
      xkb.layout = "pl";
      xrandrHeads = [
        {
          primary = true;
          output = "DVI-D-0";
          monitorConfig = ''
            Option "PreferredMode" "1920x1080"
          '';
        }
        {
          primary = false;
          output = "HDMI-0";
          monitorConfig = ''
            Option "PreferredMode" "1920x1080"
            Option "RightOf" "DVI-D-0"
          '';
        }
      ];
      wacom.wittano.enable = true;
    };

    boinc.wittano.enable = !hardware.virtualization.wittano.enableWindowsVM;
    # backup.enable = true;
    rss.enable = true;
    syncthing.wittano.enable = true;
    filebot.wittano.enable = false;
    displayManager.sddm.wittano = {
      enable = true;
      package = pkgs.catppuccin-sddm-corners;
    };
  };

}
