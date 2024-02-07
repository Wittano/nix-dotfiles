{ config, lib, pkgs, home-manager, hostname, dotfiles, ... }:
with lib;
with lib.my;
let cfg = config.modules.shell.fish;
in
{

  options = {
    modules.shell.fish = {
      enable = mkEnableOption ''
        Enable fish shell
      '';

      enableDevMode = mkEnableOption ''
        Enable fish shell in dev mode
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
      home.activation = {
        linkMutableOmfConfig = link.createMutableLinkActivation cfg ".config/omf";
        linkMutableExternalAliasesConfig = link.createMutableLinkActivation cfg ".config/fish/conf.d";
      };

      # TODO add fish old complition
      xdg.configFile = mkIf (cfg.enableDevMode == false) {
        omf.source = dotfiles.omf.source;
        "fish/conf.d".source = dotfiles.fish."conf.d".source;
      };

      # TODO Replace OMF by plugins manage by NixOS
      programs.fish = {
        enable = true;
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
            tor = "nix run nixpkgs#tor-browser-bundle-bin";

            # Projects
            pnix = "cd $NIX_DOTFILES";
            plab = "cd $HOME/projects/config/home-lab";

            # Nix
            nfu = "nix flake update";
            repl = "nix repl -f '<nixpkgs>'";
          };
      };
    };
  };
}
