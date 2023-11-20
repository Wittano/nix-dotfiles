{ config
, pkgs
, unstable
, lib
, home-manager
, username
, isDevMode ? false
, ownPackages
, ...
}: {

  # Nix configuration
  nix = {
    settings = {
      max-jobs = 4;
      cores = 4;
      auto-optimise-store = true;
      substituters = [
        "https://wittano-nix-repo.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "wittano-nix-repo.cachix.org-1:SqjGwMsbzVQOXhbS90DXFC7AoGH99dzPy8zixK3cyt0="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
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
    keyMap = "pl";
  };

  services.xserver.layout = "pl";

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals =
    lib.mkIf (config.services.xserver.desktopManager.gnome.enable == false)
      [ pkgs.xdg-desktop-portal-gtk ];

  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/current-system/sw/bin"
  '';

  # Fonts
  fonts.fonts = with pkgs; [
    source-code-pro
    hanazono
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji-blob-bin
    jetbrains-mono
    nerdfonts
    hackgen-nf-font
  ];

  # Global packages
  environment = {
    systemPackages = with pkgs; [ vim htop direnv bash ];
    variables =
      let projectConfigDir = "/home/wittano/projects/config";
      in {
        EDITOR = "vim";
        DOTFILES = "${projectConfigDir}/dotfiles";
        NIX_DOTFILES = "${projectConfigDir}/nix-dotfiles";
      };

    shells = with pkgs; [ bash ];
  };

  # Linux Kernel settings
  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "xhci_pci" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };

    tmp.useTmpfs = true;

    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };

    extraModulePackages = [ ];

    plymouth = {
      enable = true;
      themePackages = with ownPackages; [ nixos-blur ];
      theme = "nixos-blur";
    };
  };

  hardware.trackpoint.emulateWheel = true;

  #User settings
  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Home-manager
  home-manager = {
    extraSpecialArgs = { inherit pkgs unstable lib; };
    useUserPackages = true;
    backupFileExtension = "backup";
    users.wittano = {
      home.stateVersion = "23.05";
      services.home-manager.autoUpgrade = {
        enable = true;
        frequency = "daily";
      };
    };
  };

  # Internal modules
  modules = {
    desktop.sddm = {
      enable = true;
      theme = "sugar-candy";
    };
    utils = {
      enable = true;
      enableGlobalUtils = true;
    };
    themes.catppuccin.enable = true;
    dev.git.enable = true;
    shell.fish = {
      enable = true;
      enableDevMode = isDevMode;
      default = true;
    };
  };

  # System
  system = {
    autoUpgrade = {
      enable = true;
      flake = "github:wittano/nix-dotfiles";
    };
    stateVersion = "23.05";
  };

}
