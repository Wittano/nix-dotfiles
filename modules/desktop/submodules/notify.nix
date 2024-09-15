{ pkgs, ... }:
let
  timeNotify = pkgs.writeShellApplication {
    name = "time-notify";
    runtimeInputs = with pkgs; [ libnotify coreutils ];
    text = ''
      notify-send -t 2000 "$(date)"
    '';
  };
in
{
  config = {
    home-manager.users.wittano.home.packages = [ timeNotify ];
  };
}
