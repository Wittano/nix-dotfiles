{ config, lib, pkgs, hostname, templateDir, desktopName, ... }:
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

  completions = attrsets.mapAttrs'
    (n: v: {
      name = "fish/completions/${n}.fish";
      value =
        let
          fieldName =
            if builtins.typeOf v == "string"
            then "text"
            else "source";
        in
        { "${fieldName}" = v; };
    })
    cfg.completions;
in
{

  options = {
    modules.shell.fish = {
      enable = mkEnableOption "Enable fish shell";
      enableDirenv = mkEnableOption "Enable direnv";
      default = mkEnableOption "Enable fish shell as default shell for main user";
      completions = mkOption {
        type = with types; attrsOf (either str path);
        default = { };
        description = "List of custom completions";
        example = {
          "myprog" = "complete -c myprog -F -r";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.wittano.shell = mkIf cfg.default pkgs.fish;

    programs.fish.enable = cfg.enable;

    environment.shells = mkIf cfg.default (with pkgs; [ fish ]);

    home-manager.users.wittano = {
      xdg.configFile = completions;

      programs = {
        direnv = {
          enable = cfg.enableDirenv;
          nix-direnv.enable = cfg.enableDirenv;
          config = {
            global = {
              load_dotenv = true;
              disable_stdin = true;
            };
            whitelist.prefix = [ "/home/wittano/projects" ];
          };
        };

        fish = {
          enable = true;
          plugins = officialPlugins ++ customePlugins;
          shellAliases =
            let
              host = (strings.removeSuffix "-dev" hostname) +
                (strings.optionalString (desktopName != "") "-${desktopName}");
                
              templatesAliases = attrsets.mapAttrs'
                (n: v: {
                  name = "t${n}";
                  value = "${pkgs.nixFlakes}/bin/nix flake init --template $NIX_DOTFILES#${n}";
                })
                (builtins.readDir templateDir);

              rebuildDesktop = type:
                let
                  desktops = attrsets.mapAttrs'
                    (n: value: {
                      inherit value;
                      name = strings.removeSuffix ".nix" n;
                    })
                    (builtins.readDir ./../desktop/wm);
                in
                attrsets.mapAttrs'
                  (n: v:
                    let
                      nixosConfig = "${hostname}-${n}" + (strings.optionalString (type == "dev") "-dev");
                    in
                    {
                      name = if type != "dev" then "re-${n}" else "dev-${n}";
                      value = rebuild nixosConfig;
                    })
                  desktops;

              rebuildDesktopAliases = (rebuildDesktop "") // (rebuildDesktop "dev");

              rebuild = name:
                let
                  impureFlag = optionalString config.modules.services.syncthing.enable "--impure";
                  profile = "${config.environment.variables.NIX_DOTFILES}#${name}";
                in
                "sudo nixos-rebuild switch --flake ${profile} ${impureFlag}";
            in
            {
              xc = "xprop | grep CLASS";
              re = rebuild host;
              dev = rebuild "${host}-dev";

              # Programs
              neofetch = "nix run nixpkgs#neofetch";
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
              scr = "sudo systemctl restart";
              sdb = "systemd-analyze blame";
            } // templatesAliases // rebuildDesktopAliases;
        };
      };
    };
  };
}
