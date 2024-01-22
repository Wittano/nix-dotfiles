{ config
, pkgs
, unstable
, lib
, home-manager
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

  # Fonts
  fonts.packages = with pkgs; [
    source-code-pro
    hanazono
    noto-fonts
    noto-fonts-extra
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji-blob-bin
    jetbrains-mono
    nerdfonts
    hackgen-nf-font
  ];

  # Global packages
  environment = {
    systemPackages = with pkgs; [ vim htop direnv bash polkit_gnome ];
    variables =
      let projectConfigDir = "/home/wittano/projects/config";
      in
      {
        EDITOR = "vim";
        DOTFILES = "${projectConfigDir}/dotfiles";
        NIX_DOTFILES = "${projectConfigDir}/nix-dotfiles";
      };

    shells = with pkgs; [ bash ];
  };

  # Linux Kernel settings
  boot = {
    supportedFilesystems = [ "ntfs" ];
    initrd = {
      availableKernelModules = [ "ahci" "xhci_pci" "sd_mod" "sr_mod" ];
    };

    tmp.cleanOnBoot = true;

    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };

    plymouth = {
      enable = true;
      themePackages = with ownPackages; [ nixos-blur ];
      theme = "nixos-blur";
    };
  };

  hardware.trackpoint.emulateWheel = true;

  #User settings
  users.users.wittano = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Home-manager
  home-manager = {
    extraSpecialArgs = { inherit pkgs unstable lib; };
    useUserPackages = true;
    backupFileExtension = "backup";
    users.wittano = {
      home.stateVersion = "23.11";
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
    services.autoUpgrade.enable = true;
  };

  # QT
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "adwaita-dark";
  };

  # System
  system.stateVersion = "23.11";

  security.polkit.enable = true;

}
