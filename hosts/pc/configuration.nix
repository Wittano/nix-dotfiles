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

  fixedSignal = pkgs.signal-desktop.overrideAttrs (oldAttrs: {
    preFixup = oldAttrs.preFixup + ''
      substituteInPlace $out/share/applications/${oldAttrs.pname}.desktop \
      --replace "$out/bin/${oldAttrs.pname}" "$out/bin/${oldAttrs.pname} --use-tray-icon"
    '';
  });
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
      automatic = !programs.nh.enable;
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
    supportedFilesystems = {
      ntfs = true;
      nfs = true;
    };
    initrd.availableKernelModules = [ "ahci" "xhci_pci" "sd_mod" "sr_mod" ];

    tmp.cleanOnBoot = true;

    loader = {
      grub.wittano = {
        enable = true;
        enableMultiBoot = true;
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
    enable = mkForce false;
    accent = "peach";
    flavor = "frappe";
  };

  programs = {
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = nix.gc.options;
      };
    };
    fish.enable = true;
    file-roller.enable = true; # Archive explorer
    evince.enable = true; # PDF viever
    droidcam.enable = true;
    steam.wittano.enable = true;
    mihoyo = {
      enable = true;
      games = [ "honkai-railway" ];
    };
  };

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

          fish.shellAliases.open = "xdg-open";
          mpv.enable = true;
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

        home.packages = with pkgs; [
          # Utils
          flameshot

          # Folder Dialog menu
          gnome.zenity

          # Web browser
          vivaldi

          # Utils 
          thunderbird # Mail
          gnome.eog # Image viewer
          onlyoffice-bin # Office staff
          cinnamon.nemo

          # Apps
          spotify
          logseq
          # unstable.joplin-desktop # Notebook
          # unstable.vscodium # VS code
          minder # Mind maps
          # insomnia # REST API Client
          gnome.pomodoro
          unstable.figma-linux # Figma

          # Security
          bitwarden
        ];
      };
    in
    {
      extraSpecialArgs = { inherit pkgs unstable lib inputs; };
      useUserPackages = true;
      backupFileExtension = "backup";
      users.wittano = mkMerge [
        {
          programs = {
            jetbrains.ides = [ "go" "fork" "python" "cpp" "jvm" ];
            git.wittano.enable = true;
            rofi.wittano.enable = true;

            games.enable = true;
            lutris.enable = true;

            tmux.wittano.enable = true;
            neovim.wittano.enable = true;

            fish.shellAliases = {
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

          desktop.autostart = {
            desktopName = "openbox";
            scriptPath = ".config/openbox/autostart";
            programs = [
              "vivaldi"
              "spotify"
              "vesktop"
              "thunderbird"
              "steam"
              "signal-desktop --use-tray-icon --no-sandbox"
            ];
          };

          gtk.gtk3.bookmarks = [
            "file://${environment.variables.NIX_DOTFILES} Nix configuration"
            "file://${environment.variables.NIX_DOTFILES}/dotfiles Dotfiles"
          ];

          home.packages = with pkgs; [
            # Utilities
            sshs

            # Tilling WM
            timeNotify
            showVolume

            # Apps
            unstable.figma-linux # Figma
            # Web browser
            vivaldi

            # Apps
            gnome.pomodoro

            # Social media
            # telegram-desktop
            unstable.freetube # Youtube desktop
            fixedSignal # Signal desktop
            # element-desktop # matrix communicator
            vesktop
            # irssi # IRC chat
            unstable.streamlink-twitch-gui-bin
          ];
        }
        commonConfig
      ];
    };

  # Programs
  services.locate = {
    enable = true;
    interval = "21:37";
  };

  desktop.openbox = {
    enable = true;
    users = [ "wittano" ];
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

  virtualisation.docker.wittano.enable = true;

  services = {
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

    boinc.wittano.enable = true;
    backup.enable = true;
    rss.enable = true;
    syncthing.wittano.enable = true;
    filebot.wittano.enable = true;
    displayManager.sddm.wittano = {
      enable = true;
      package = pkgs.catppuccin-sddm-corners;
    };
  };
}
