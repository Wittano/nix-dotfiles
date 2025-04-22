{ config, lib, pkgs, ... }:
with lib;
{
  options.profile.programming.enable = mkEnableOption "programming stuff";

  config = mkIf config.profile.programming.enable {
    programs = {
      jetbrains.ides = [ "go" "cpp" "sql" "elixir" "haskell" ];
      tmux.wittano.enable = true;
      fish.shellAliases = {

        # Projects
        pnix = "cd $HOME/nix-dotfiles";
        plab = "cd $HOME/projects/server/home-lab";

        # Nix
        nfu = "nix flake update";
        nfc = "nix flake check";
        repl = "nix repl -f '<nixpkgs>'";

        # systemd
        scs = "sudo systemctl status";
        scst = "sudo systemctl stop";
        scsta = "sudo systemctl start";
        sce = "sudo systemctl enable --now";
        scr = "sudo systemctl restart";
        sdb = "systemd-analyze blame";
      };
    };

    gtk.gtk3.bookmarks = [
      "file://$HOME/nix-dotfiles Nix configuration"
    ];

    home.packages = with pkgs; [
      sshs # SSH client
      joplin-desktop
      vscodium # VS code
      signal-desktop # Signal communicator
    ];
  };
}

