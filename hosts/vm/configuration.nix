{ pkgs, ... }: {
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
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ firefox vscode ];
  };

  environment.systemPackages = with pkgs; [ git ];

  modules.services.ssh.enable = true;

}
