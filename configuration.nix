{ config, pkgs, unstable, lib, home-manager,  ... }:
let jobs = 16;
in {

  # Nix configuration
  nix = {
    maxJobs = jobs;
    gc.automatic = true;
    autoOptimiseStore = true;
    buildCores = jobs;
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
    variables.EDITOR = "vim";

    shells = with pkgs; [ bash ];
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
