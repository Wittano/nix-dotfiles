# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let homeDir = "/home/wittano";
in {

  # System
  system.autoUpgrade = {
    enable = true;
    # If varable is true, it'll auto reboot, when updating of NixOS will be finished
    allowReboot = false;
  };

  # Time settings
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  fonts.fonts = with pkgs; [
    powerline-fonts
    font-awesome_5
    source-code-pro
  ];

  # Enable sound.
  sound.enable = true;

  # Enviroment variables
  environment.variables = {
    EDITOR = "vim";
    NIX_BUILD_CORES = "4";
    NIXOS_CONFIG = "${homeDir}/dotfiles/nix/os/configuration.nix";
    DOTFILES_DIR = "${homeDir}/dotfiles";

    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
  };

  environment.shells = with pkgs; [ fish bash ];

  users.users.wittano = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "docker" "libvirtd" ];
  };

  # Global packages
  environment.systemPackages = with pkgs; [ vim virt-manager fish htop ];

  # Virtualization
  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  # System version
  system.stateVersion = "21.11";

}
