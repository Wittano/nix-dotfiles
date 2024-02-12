{ config, lib, pkgs, home-manager, hostname, dotfiles, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.shell.fish;
  officialPlugins = builtins.map
    (x: {
      name = x;
      src = pkgs.fishPlugins.${x};
    }) [
    "wakatime-fish"
    "plugin-git"
    "autopair"
    "fzf-fish"
    "bass"
    "sponge"
    "fzf"
    "grc"
    "z"
    "humantime-fish"
    "colored-man-pages"
    "done"
    "tide"
  ];
  customePlugins = [
    {
      name = "batman-theme";
      src = pkgs.fetchFromGitHub {
        owner = "oh-my-fish";
        repo = "theme-batman";
        rev = "2a76bd81f4805debd7f137cb98828bff34570562";
        sha256 = "sha256-Ko4w9tMnIi17db174FzW44LgUdui/bUzPFEHEHv//t4=";
      };
    }
    {
      name = "dracula-theme";
      src = pkgs.fetchFromGitHub {
        owner = "dracula";
        repo = "fish";
        rev = "269cd7d76d5104fdc2721db7b8848f6224bdf554";
        sha256 = "sha256-Hyq4EfSmWmxwCYhp3O8agr7VWFAflcUe8BUKh50fNfY=";
      };
    }
  ];
in
{

  options = {
    modules.shell.fish = {
      enable = mkEnableOption ''
        Enable fish shell
      '';

      default = mkEnableOption ''
        Enable fish shell as default shell for main user
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.wittano.shell = mkIf cfg.default pkgs.fish;

    programs.fish.enable = cfg.enable;

    environment.shells = mkIf cfg.default (with pkgs; [ fish ]);

    home-manager.users.wittano = {
      programs.fish = {
        enable = true;
        plugins = officialPlugins ++ customePlugins;
        interactiveShellInit = ''
          direnv hook fish | source
        '';
        shellAliases =
          let
            host = builtins.replaceStrings [ "-dev" ] [ "" ] hostname;
            templatesAliases = attrsets.mapAttrs'
              (n: v: {
                name = "t${fixedName}";
                value = "${pkgs.nixFlakes}/bin/nix flake init --template github:Wittano/nix-dotfiles#${n}";
              })
              (builtins.readDir ./../../templates);
            rebuild = name:
              let
                impureFlag = optionalString config.modules.services.syncthing.enable "--impure";
              in
              "sudo nixos-rebuild switch --flake ${config.environment.variables.NIX_DOTFILES}#${name} ${impureFlag}";
          in
          {
            xc = "xprop | grep CLASS";
            re = rebuild host;
            dev = rebuild "${host}-dev";

            # Programs
            neofetch = "nix run nixpkgs#neofetch";
            btop = "nix run nixpkgs#btop";
            onefetch = "nix run nixpkgs#onefetch";
            py = "nix run nixpkgs#python3";

            # Projects
            pnix = "cd $NIX_DOTFILES";
            plab = "cd $HOME/projects/config/home-lab";

            # Nix
            nfu = "nix flake update";
            nfc = "nix flake check";
            repl = "nix repl -f '<nixpkgs>'";

            # systemd
            scs = "sudo systemctl status";
            scst = "sudo systemctl stop";
            scsta = "sudo systemctl start";
            sce = "sudo systemctl enable --now";
            scd = "sudo systemctl disable --now";
            scr = "sudo systemctl restart";
            sdb = "systemd-analyze blame";
          };
      };
    };
  };
}
