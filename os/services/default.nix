{ config, pkgs, homeDir, ... }: {
  imports = [
    ./boinc.nix
    ./xorg.nix
    (import ./syncthing.nix {
      inherit config pkgs;
      homeDir = homeDir;
    })
  ];

  services.openssh.enable = true;
}
