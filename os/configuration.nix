# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
   mainUser = if builtins.pathExists /home/wittano then "wittano" else "nixos";
   homeDir =  "/home/${mainUser}";
   homeConfigDir = "${homeDir}/dotfiles/home";
   homeManager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
   homeManagerConfig = "${homeConfigDir}/home.nix";
in
{
  # Nix configuration
  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;
  nix.autoOptimiseStore = true;

  imports =
    [ 
      ./hardware-configuration.nix
      (import "${homeManager}/nixos")
    ];

  # Auto Updating
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false; # If varable is true, it'll auto reboot, when updating of NixOS will be finished

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      enable = true;
      version = 2;
      device = "nodev";
    };
  };

  # Time settings
  time.timeZone = "Europe/Warsaw";

  # Networking
  networking = {

    hostName = "nixos"; # Define your hostname.
    useDHCP = false;
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [ {
        address = "192.168.1.160";
        prefixLength = 24;
      } ];
   };

    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" ];
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [ 31416 ];
    };

  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
    openssh.enable = true; # SSH deamon

    syncthing = {
      enable = true;
      systemService = true;
      configDir = "${homeDir}/.config/syncthing";
      user = "wittano";
      folders = {
        "${homeDir}/Music" = {
	  id = "epc3d-xkkkk";
	  label = "Music";
	  devices = [ "phone" ];
	};

	"${homeDir}/.keepass" = {
	  id = "xm73k-khame";
	  label = "Passwords";
	  devices = [ "phone" ];
	};
      };
      devices = {
        phone = {
          id = "WOQUTMO-7NJ7ONW-TMJ27JC-ENUM6QN-WE35NQO-MEUP3VQ-FEMMI2E-TCT4LQ4";
        };
      };
      extraOptions = {
        gui.theme = "dark";
      };
    };

    boinc = {
      enable = true;
      extraEnvPackages = with pkgs; [ ocl-icd linuxPackages.nvidia_x11 ];
      allowRemoteGuiRpc = true;
    };

    xserver = {
      enable = true;
      layout = "pl";
      videoDrivers = [ "nvidia" ];
      xautolock.enable = true;

      # Window manager
      windowManager.openbox.enable = true;

      displayManager = {
        defaultSession = "none+openbox";
	gdm.enable = true;
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

  # Hardware
  hardware = {
    
    trackpoint.emulateWheel = true;

    pulseaudio = {
      enable = true;
      support32Bit = config.hardware.pulseaudio.enable;
    };

    # OpenGL and Vulkan
    nvidia.modesetting.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      setLdLibraryPath = true;
      extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wittano = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "docker" "libvirtd" ]; # Enable ‘sudo’ for the user.
  };

  programs.fish.enable = true;

  # Enviroment variables
  environment.variables = {
   EDITOR = "vim";
   NIX_BUILD_CORES = "4";
   NIXOS_CONFIG = "${homeDir}/dotfiles/nix/os/configuration.nix";
   HOME_MANAGER_CONFIG = homeManagerConfig;

  __NV_PRIME_RENDER_OFFLOAD = "1";
  __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  __VK_LAYER_NV_optimus = "NVIDIA_only";
  };

  # Home-manager
  home-manager = {
    users.wittano = import homeManagerConfig;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # Global packages
  environment.systemPackages = with pkgs; [
    # Dev
    vim
    virt-manager

    # Games
    steam
    steam-run-native
  ];

  # Virtualization
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  # programs.dconf.enable = true;
  # programs.fish.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # System version
  system.stateVersion = "21.11";

}
