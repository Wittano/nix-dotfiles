{ config, pkgs, isDevMode ? false, ... }: {

  imports = [ ./hardware.nix ];

  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver = {
    layout = "pl";
    xkbVariant = "";
  };

  console.keyMap = "pl2";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.virt = {
    isNormalUser = true;
    description = "virt";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    vscode
    direnv
    git
  ];

  home-manager.users.virt.services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };

  modules = let
    onlyEnableWithDevMode = {
      enableDevMode = isDevMode;
      enable = true;
    };
  in {
    services = {
      ssh.enable = true;
    };
  };

}
