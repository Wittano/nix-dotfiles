{ config, pkgs, unstable, lib, home-manager, username, isDevMode ? false, ... }: {

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
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Warsaw";

  # Locale
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.utf8";
      LC_IDENTIFICATION = "pl_PL.utf8";
      LC_MEASUREMENT = "pl_PL.utf8";
      LC_MONETARY = "pl_PL.utf8";
      LC_NAME = "pl_PL.utf8";
      LC_NUMERIC = "pl_PL.utf8";
      LC_PAPER = "pl_PL.utf8";
      LC_TELEPHONE = "pl_PL.utf8";
      LC_TIME = "pl_PL.utf8";
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
  xdg.portal.extraPortals = lib.mkIf (config.services.xserver.desktopManager.gnome.enable == false)
    [ pkgs.xdg-desktop-portal-gtk ];

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
    systemPackages = with pkgs; [ vim htop direnv ];
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

    loader.efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };

    extraModulePackages = [ ];
  };

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
    users.wittano.home.stateVersion = "22.05";
  };

  # Internal modules
  modules = {
    themes = {
      enable = true;
      gruvbox.enable = true;
    };
    dev = {
      git.enable = true;
    };
    shell.fish = {
      enable = true;
      enableDevMode = isDevMode;
      default = true;
    };
  };

  # System
  system = {
    autoUpgrade.enable = true;
    stateVersion = "22.11";
  };

}
