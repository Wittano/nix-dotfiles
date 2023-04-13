{ config, ... }:

{
  imports = [
    ./wacom.nix
    ./bootloader.nix
    ./nvidia.nix
    ./sound.nix
    ./virutalization.nix
    ./bluetooth.nix
  ];

  config.hardware.trackpoint.emulateWheel = true;

}
