{ config, pkgs, lib, home-manager, username, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.dev.jvm;
  patcherDir = pkgs.writeScriptBin "patcherDir" ''
    #/usr/bin/env bash

    programs=$(${pkgs.findutils}/bin/find $1 -type f -perm /u=x -exec ${pkgs.file}/bin/file --mime-type {} \; | ${pkgs.gnugrep}/bin/grep -E "application/(x-executable)|(x-pie-executable)" | ${pkgs.coreutils}/bin/cut -d ':' -f 1)

    if [ -z $programs ]; then
      ${pkgs.coreutils}/bin/echo "Nothing changes"
    fi

    for p in $programs; do
      ${pkgs.coreutils}/bin/echo "Patch progam $p"
      ${pkgs.patchelf}/bin/patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 "$p"
    done
  '';
in
{
  options = {
    modules.dev.jvm = {
      enable = mkEnableOption ''
        Enable JVM development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [ jetbrains.idea-ultimate android-studio jdk gradle patcherDir ];
        file.".ideavimrc".text = ''
          set rnu nu
        '';
      };
    };
  };
}
