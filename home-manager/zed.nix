{ config, lib, pkgs, ... }: with lib;{
  options.programs.zed-editor.wittano.enable = mkEnableOption "zed-editor";

  config = mkIf config.programs.zed-editor.wittano.enable {
    programs.zed-editor = {
      enable = true;

      extensions = [ "catppuccin" "nix" "html" "html-snippets" "log" "ansible" "terraform" ];

      extraPackages = with pkgs; [
        nixd
        nixfmt-classic
        nodePackages.prettier
        terraform-ls
        ansible
        ansible-lint
        yaml-language-server
        python3Full
      ];

      userSettings = {
        base_keymap = "JetBrains";
        features.copilot = false;
        telemetry.metrics = false;
        ui_font_size = 16;
        buffer_font_size = 18;
        lsp = {
          nixd = {
            settings = {
              formatting.command = [ "nixfmt" ];
              nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.<name>.options";
              home-manager.expr = "(import <home-manager/modules> { configuration = ~/.config/home-manager/home.nix; pkgs = import <nixpkgs> {}; }).options";

              diagnostic.suppress = [ "sema-extra-with" ];
            };
          };
        };
      };
    };
  };
}
