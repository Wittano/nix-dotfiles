{ config, inputs, lib, pkgs, ... }:
with lib;
with lib.my;
let
  themeDir = mapper.mapDirToAttrs inputs.catppuccin-dunst;
  mkThemeContent = content: builtins.replaceStrings [ " frame" ] [ "\"frame\"" ] content;
  mkTheme = name: trivial.pipe themeDir.themes."${name}.conf".source [
    builtins.readFile
    mkThemeContent
    builtins.fromTOML
  ];
in
{
  options.services.dunst.wittano.enable = mkEnableOption "Enable custom alacritty config";

  config = rec {
    fonts.fontconfig.enable = services.dunst.enable;
    home.packages = mkIf services.dunst.enable [ pkgs.jetbrains-mono ];

    services.dunst = {
      inherit (config.services.dunst.wittano) enable;

      catppuccin.enable = mkForce false;
      settings = mkMerge [
        (mkTheme config.catppuccin.flavor)
        {
          global = {
            font = "Jetbrains Mono 14";
            min_icon_size = 64;
          };
        }
      ];
    };
  };
}
