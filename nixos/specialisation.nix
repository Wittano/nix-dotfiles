{ lib, ... }: with lib;
let
  accent = "pink";
in
rec {
  # Default values
  catppuccin = {
    inherit accent;

    enable = mkForce false;
    flavor = "macchiato";
  };

  specialisation.light-theme.configuration = {
    catppuccin.flavor = mkForce "latte";
  };
  specialisation.dark-theme.configuration = {
    catppuccin.flavor = catppuccin.flavor;
  };
}
