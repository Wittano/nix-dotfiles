{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my;
let
  themeDir = mapper.mapDirToAttrs inputs.catppuccin-dunst;
  mkThemeContent = content: builtins.replaceStrings [ " frame" ] [ "\"frame\"" ] content;
  mkTheme =
    name:
    themeDir.themes."${name}.conf".source
    |> builtins.readFile
    |> mkThemeContent
    |> fromTOML;
in
{
  options.services.dunst.wittano.enable = mkEnableOption "Enable custom alacritty config";

  config = mkIf config.services.dunst.wittano.enable rec {
    fonts.fontconfig.enable = services.dunst.enable;
    home.packages = mkIf services.dunst.enable [ pkgs.jetbrains-mono ];

    catppuccin.dunst.enable = mkForce false;
    services.dunst = {
      inherit (config.services.dunst.wittano) enable;

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
