{ config, pkgs, unstable, lib, home-manager, ... }: {

  # Nix configuration
  nix = {
    maxJobs = 16;
    gc.automatic = true;
    autoOptimiseStore = true;
    buildCores = 4;
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Time settings
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  services.xserver.layout = "pl";

  # System
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };

  # Fonts
  fonts.fonts = with pkgs; [ powerline-fonts font-awesome_5 source-code-pro ];

  # Global packages
  environment = {
    systemPackages = with pkgs; [ vim htop ];
    variables = {
      EDITOR = "vim";
      DOTFILES = "/home/wittano/dotfiles";
    };

    shells = with pkgs; [ bash ];
  };

  # Linux Kernel settings
  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "xhci_pci" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };
    
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };

    extraModulePackages = [ ];
  };

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
  };

  # System version
  system.stateVersion = "21.11";

}