{ config, pkgs, unstable, lib, home-manager, ... }: {

  # Nix configuration
  nix = {
    maxJobs = 4;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
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

  # Fonts
  fonts.fonts = with pkgs; [ powerline-fonts font-awesome_5 source-code-pro ];

  # Global packages
  environment = {
    systemPackages = with pkgs; [ vim htop ];
    variables =
      let
        projectConfigDir = "/home/wittano/projects/config";
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

  # Internal modules
  modules = { 
    themes = {
      enable = true;
      dracula.enable = true;
    };
    dev = {
      git = {
        enable = true;
        useGpg = true;
      };
      cpp.enable = true;
      python = {
        enable = true;
        usePycharm = true;
      };
    };
    editors.emacs.enable = true;
    shell.fish = {
      enable = true;
      default = true;
    };
  };

  # System
  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "21.11";
  };

}
