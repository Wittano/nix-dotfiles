{ pkgs, ... }:
let
  commonInputs = with pkgs; [ libnotify coreutils ];
  timeNotify = pkgs.writeShellApplication {
    name = "time-notify";
    runtimeInputs = commonInputs;
    text = ''
      notify-send -t 2000 "$(date)"
    '';
  };
  showVolume = pkgs.writeShellApplication {
    name = "show-volume";
    runtimeInputs = commonInputs;
    text = ''
      notify-send -t 2000 "Volume: $(amixer sget Master | awk -F"[][]" '/Left:/ { print $2 }')";
    '';
  };
in
{
  config = {
    home-manager.users.wittano.home.packages = [ timeNotify showVolume ];
  };
}
