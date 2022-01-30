{ config, pkgs, ... }: {
  imports = [ ./boinc.nix ./xorg.nix ./syncthing.nix ];

  services.openssh.enable = true;
}
