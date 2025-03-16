{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.programs.fish.wittano;
  officialPlugins = builtins.map
    (x: {
      name = x;
      src = pkgs.fishPlugins.${x};
    }) [
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

  options.programs.fish.wittano = {
    enable = mkEnableOption "Enable custom fish shell config";
    enableDirenv = mkEnableOption "Enable direnv";
    completions = mkOption {
      type = with types; attrsOf (either str path);
      default = { };
      description = "List of custom completions";
      example = {
        "myprog" = "complete -c myprog -F -r";
      };
    };
  };

  config = mkIf cfg.enable {
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
          whitelist.prefix = [ "${config.home.homeDirectory}/projects" ];
        };
      };

      fish = {
        enable = true;
        plugins = officialPlugins ++ customePlugins;
        shellInit = /*fish*/''
          bind \cy backward-kill-line
          bind \cw backward-kill-bigword
        '';
        shellAliases =
          let
            templatesAliases = attrsets.mapAttrs'
              (n: v: {
                name = "t${n}";
                value = "nix flake init --template $NIX_DOTFILES#${n}";
              })
              (builtins.readDir ./../templates);
          in
          {
            xc = "xprop | grep CLASS";

            # Programs
            neofetch = "nix run nixpkgs#neofetch";
            onefetch = "nix run nixpkgs#onefetch";
            calc = "nix run nixpkgs#R";

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
          } // templatesAliases;
      };
    };
  };
}
