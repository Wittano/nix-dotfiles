{ config, inputs, lib, ... }:
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
  config = {
    home-manager.users.wittano.services.dunst = {
      enable = true;
      catppuccin.enable = mkForce false;
      settings = mkMerge [
        (mkTheme config.home-manager.users.wittano.catppuccin.flavor)
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
