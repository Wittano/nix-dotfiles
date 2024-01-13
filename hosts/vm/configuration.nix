{ config, pkgs, isDevMode ? false, ... }: {

  imports = [ ./hardware.nix ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver = {
    layout = "pl";
    xkbVariant = "";
  };

  security.rtkit.enable = true;

  users.users.wittano = {
    isNormalUser = true;
    description = "virt";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ firefox vscode ];
  };

  environment.systemPackages = with pkgs; [ direnv git ];

  modules = {
    services.ssh.enable = true;
    desktop.openbox = {
      enable = true;
      enableDevMode = isDevMode;
    };
  };

}
