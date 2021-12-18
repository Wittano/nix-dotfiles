# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  # Nix configuration
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Auto Updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false; # If varable is true, it'll auto reboot, when updating of NixOS will be finished

  # Bootloader
  boot.loader.systemd-boot.enable = true;

  # Time settings
  time.timeZone = "Europe/Warsaw";

  # Networking
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = false;
  networking.interfaces.enp1s0.ipv4.addresses = [ {
   address = "192.168.122.83";
   prefixLength = 24;
  } ];
  networking.defaultGateway = "192.168.122.1";
  networking.nameservers = [ "8.8.8.8" ];
  networking.firewall.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  # Services
  services = {
    openssh.enable = true;

    syncthing = {
      enable = true;
      systemService = true;
      declarative = {
        devices = {
          phone = {
            id = "WOQUTMO-7NJ7ONW-TMJ27JC-ENUM6QN-WE35NQO-MEUP3VQ-FEMMI2E-TCT4LQ4";
          };
        };
      };
    };

    boinc = {
      enable = true;
      extraEnvPackages = with pkgs; [ ocl-icd linuxPackages.nvidia_x11 ];
    };

    # X server
    xserver = {
      enable = true;

      layout = "pl";
      xkbOptions = "eurosign:e";

      # Window manager
      windowManager = {
	openbox.enable = true;
      };

      displayManager = {
	defaultSession = "none+openbox";
	lightdm.enable = true;
      };
    };
  };

  fonts.fonts = with pkgs; [
    powerline-fonts
    font-awesome_5
    source-code-pro
  ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable video card
  # services.xserver.videoDrivers = [ "nvidia" ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wittano = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
  };

  # Enviroment variables
  environment.variables = {
    EDITOR="vim";
    NIX_BUILD_CORES="4";
    NIXOS_CONFIG="/home/wittano/dotfiles/nix/os/configuration.nix";
    HOME_MANAGER_CONFIG_DIR="$HOME/dotfiles/nix/home-manager";
  };

  # Global packages
  environment.systemPackages = with pkgs; [
    vim 
    wget
    python3
    virt-manager
  ];

  # Virtualization
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };
  
  programs.dconf.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # System version
  system.stateVersion = "21.11"; # Did you read the comment?

}
