{ config, pkgs, isDevMode ? false, username ? "wittano", ... }: {

  imports = [ ./hardware.nix ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver = {
    layout = "pl";
    xkbVariant = "";
  };

  security.rtkit.enable = true;

  users.users."${username}" = {
    isNormalUser = true;
    description = "virt";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ firefox ];
  };

  environment.systemPackages = with pkgs; [ vim vscode direnv git ];

  modules = {
    services.ssh.enable = true;
    desktop.openbox = {
      enable = true;
      enableDevMode = isDevMode;
    };
  };

}
