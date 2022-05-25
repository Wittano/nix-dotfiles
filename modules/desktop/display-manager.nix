{ config, pkgs, lib, ... }:
{
  # NOTE!
  # Every modules, that added here, shoudn't start at "service"
  # because modules is added to "service" module in 
  # desktop configuration e.g. openbox.nix or bspwm.nix
  # Incorrect:
  #
  # someModule = {
  #   service.xserver.displayManager...
  # }
  #
  # Correct:
  # someModule = {
  #   xserver.displayManager...
  # }
  #

  gdm = {
      xserver.displayManager.gdm.enable = true;    
  };

  lightdm = {}; # TODO Add configuration
    
  sddm = {}; # TODO Add configuration
}
