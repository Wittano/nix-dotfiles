{ pkgs
, unstable
, lib
, privateRepo
, ...
}: {

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
    package = pkgs.nixFlakes;
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
    systemPackages = with pkgs; [ vim htop bash ];
    variables =
      let projectConfigDir = "/home/wittano/projects/config";
      in
      {
        EDITOR = "vim";
        DOTFILES = "${projectConfigDir}/nix-dotfiles/dotfiles";
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
      themePackages = with privateRepo; [ nixos-blur-playmouth ];
      theme = "nixos-blur";
    };
  };

  hardware.trackpoint.emulateWheel = true;

  #User settings
  users.users.wittano = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # TODO Added nh after upgrade system to 24.05 version

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
    utils = {
      enable = true;
      enableGlobalUtils = true;
    };
    dev.git.enable = true;
    shell.fish = {
      enable = true;
      enableDirenv = true;
      default = true;
    };
  };

  # System
  system.stateVersion = "23.11";

}
