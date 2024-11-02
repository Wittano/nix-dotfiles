{ config, lib, pkgs, hostname, inputs, unstable, ... }:
with lib;
with lib.my;
let
  commonInputs = with pkgs; [ libnotify coreutils ];
  timeNotify = pkgs.writeShellApplication {
    name = "time-notify";
    runtimeInputs = commonInputs;
    text = ''
      notify-send -t 2000 "$(date)"
    '';
  };
  showVolume = pkgs.writeShellApplication {
    name = "show-volume";
    runtimeInputs = commonInputs;
    text = ''
      notify-send -t 2000 "Volume: $(amixer sget Master | awk -F"[][]" '/Left:/ { print $2 }')";
    '';
  };
in
rec {

  imports = [ ./hardware.nix ./networking.nix ];

  # Nix configuration
  nix = {
    settings = {
      max-jobs = 4;
      cores = 4;
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

  services.xserver.xkb.layout = "pl";

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
      let
        homeDir = config.home-manager.users.wittano.home.homeDirectory;
      in
      {
        EDITOR = "vim";
        DOTFILES = "${homeDir}/nix-dotfiles/dotfiles";
        NIX_DOTFILES = "${homeDir}/nix-dotfiles";
      };

    shells = with pkgs; [ bash fish ];
  };

  # Linux Kernel settings
  boot = {
    supportedFilesystems.ntfs = true;
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "sd_mod" "sr_mod" ];

    tmp.cleanOnBoot = true;

    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };

    plymouth = {
      enable = true;
      themePackages = with pkgs; [ nixos-blur-playmouth ];
      theme = "nixos-blur";
    };
  };

  sound.wittano.enable = true;

  hardware = {
    trackpoint.emulateWheel = true;
    keyboard.zsa.enable = true;

    virtualization.wittano = mkIf (!boot.loader.grub.wittano.enableMultiBoot) {
      enable = true;
      enableWindowsVM = true;
    };
    nvidia.enable = true;
    samba.enable = true;
    printers.wittano.enable = true;
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

    femttano = {
      isNormalUser = true;
      uid = mkDefault 2137;
      shell = pkgs.fish;
      extraGroups = [ "gaming" ];
    };

    labottano = {
      isNormalUser = true;
      shell = pkgs.fish;
      uid = mkDefault 1003;
    };
  };

  catppuccin = {
    enable = mkForce false;
    accent = "peach";
    flavor = "frappe";
  };

  programs.fish.enable = true;

  # Home-manager
  home-manager =
    let
      commonConfig = {
        imports = [
          inputs.catppuccin.homeManagerModules.catppuccin
          inputs.nixvim.homeManagerModules.nixvim
          ./../../home-manager
        ];
        home.stateVersion = system.stateVersion;

        programs = {
          btop.enable = true;
          feh.wittano.enable = true;
          kitty.wittano.enable = true;
          fish.wittano = {
            enable = true;
            enableDirenv = true;
          };
        };
        qt.wittano.enable = true;
        gtk.wittano.enable = true;

        catppuccin = {
          enable = true;
          accent = catppuccin.accent;
          flavor = catppuccin.flavor;
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
      };
    in
    {
      extraSpecialArgs = { inherit pkgs unstable lib inputs; };
      useUserPackages = true;
      backupFileExtension = "backup";
      users.wittano = {
        programs = {
          jetbrains.ides = [ "go" "fork" "python" "cpp" "jvm" ];
          git.wittano.enable = true;
          tmux.wittano.enable = true;
          neovim.wittano.enable = true;
          fish.wittano = {
            systemConfigPath = environment.variables.NIX_DOTFILES;
            profileName = hostName;
          };
        };

        desktop.autostart.desktopName = "xmonad";

        gtk.gtk3.bookmarks = [
          "file://${environment.variables.NIX_DOTFILES} Nix configuration"
          "file://${environment.variables.NIX_DOTFILES}/dotfiles Dotfiles"
        ];
        home.packages = with pkgs; [ sshs timeNotify showVolume ];
      } // commonConfig;
      users.femttano = {
        programs = {
          games.enable = true;
          lutris.wittano.enable = true;
        };
        desktop.autostart.desktopName = "openbox";
        services.picom.wittano.exceptions = [
          config.programs.steam.package
        ];
      } // commonConfig;
      users.labottano = {
        home.packages = with pkgs; [ teams ];
        desktop.autostart.desktopName = "openbox";
      } // commonConfig;
    };

  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  services.devmon.enable = true;
  services.gvfs.enable = true;

  # Programs
  services.locate = {
    enable = true;
    interval = "21:37";
  };

  desktop = {
    xmonad = {
      enable = true;
      users = [ "wittano" ];
    };
    openbox = {
      enable = true;
      users = [ "femttano" "labottano" ];
    };
  };

  # System
  system = {
    stateVersion = "24.05";
    autoUpgrade = {
      enable = true;
      flake = "github:wittano/nix-dotfiles#${hostname}";
      dates = "daily";
    };
  };

  services.xserver.xrandrHeads = [
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

  boot.supportedFilesystems.nfs = true;

  programs = {
    droidcam.enable = true;
    steam.wittano.enable = true;
    mihoyo = {
      enable = true;
      games = [ "honkai-railway" ];
    };
  };

  boot.loader.grub.wittano = {
    enable = true;
    theme = inputs.honkai-railway-grub-theme.packages.${system}.dr_ratio-grub-theme;
    enableMultiBoot = true;
  };

  virtualisation.docker.wittano.enable = true;
  services = {
    boinc.wittano.enable = true;
    backup.enable = true;
    rss.enable = true;
    syncthing.wittano.enable = true;
    filebot.wittano.enable = true;
  };
}
