{ config, pkgs, isDevMode ? false, username ? "virt", ... }: {

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

  home-manager.users."${username}".services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };

  modules = {
    hardware.sound = {
        enable = true;
        driver = "pipewire";
    };
    services.ssh.enable = true;
    desktop.gnome.enable = true;
  };

}
