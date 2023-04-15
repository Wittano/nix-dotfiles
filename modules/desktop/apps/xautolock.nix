{ pkgs, ... }: {
  services.xserver.xautolock = {
    enable = true;
    time = 15;
    enableNotifier = true;
    notifier = ''${pkgs.libnotify}/bin/notify-send "Locking in 10 seconds"'';
  };
}
