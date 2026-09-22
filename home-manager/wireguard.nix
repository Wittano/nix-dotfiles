{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  options.programs.wireguard.enable = mkEnableOption "wireguard client-side configuration";

  config = mkIf config.programs.wireguard.enable {
    home.packages = [ pkgs.wireguard-tools ];
  };
}
