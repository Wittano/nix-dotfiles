{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
{
  options.programs.alock.enable = mkEnableOption "alock custom configuraton";

  config = mkIf config.programs.alock.enable {
    environment.systemPackages =
      let
        alockPath = meta.getExe pkgs.alock;
        bacgroundPath = ./../../home-manager/wallpapers/65.jpg;
        locker = pkgs.writeShellScriptBin "nixos-alock" "${alockPath} -bg image:file=${bacgroundPath}";
      in
      [ locker ];
  };
}
