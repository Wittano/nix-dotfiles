{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
{
  options.programs.alock = {
    enable = mkEnableOption "alock custom configuraton";
    wallpaper = mkOption {
      type = types.path;
      description = "Path to wallpaper for alock configuration";
      default = ./../../home-manager/wallpapers/65.jpg;
    };
  };

  config = mkIf config.programs.alock.enable {
    environment.systemPackages =
      let
        alockPath = meta.getExe pkgs.alock;
        bacgroundPath = config.programs.alock.wallpaper;
        locker = pkgs.writeShellScriptBin "nixos-alock" "${alockPath} -bg image:file=${bacgroundPath}";
      in
      [ locker ];
  };
}
