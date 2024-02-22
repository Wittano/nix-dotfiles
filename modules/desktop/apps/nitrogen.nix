{ pkgs, lib, home-manager, dotfiles, cfg, ... }:
with lib;
with lib.my;
let
  toCfg = name: value:
    let
      # This script fix problem for nitrogen, becauses for some resons
      # nitrogen read path with " chars and throws exception for that
      fixCfgPaths = builtins.toFile "fixCfgPaths.py" /*python*/''
        #!/usr/bin/env python
        from typing import List
        import sys

        if len(sys.argv) < 2:
          raise AssertionError("Missing required input file")

        content: List[str] = []
        inputFile = sys.argv[1]

        with open(inputFile, "r") as f:
            for line in f:
                content.append(line)

        if len(content) <= 0:
            raise AssertionError("file is empty")

        with open(inputFile, "w") as f:
            for i, line in enumerate(content):
                if "/" in line:
                    content[i] = line.replace("\"", "")

            f.writelines(content)
      '';
    in
    ((pkgs.formats.toml { }).generate name value).overrideAttrs
      (final: prev: {
        nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.python3 ];
        buildCommand = /*bash*/ ''
          json2toml "$valuePath" $out
          python ${fixCfgPaths} $out
        '';
      });
in
{
  home-manager.users.wittano = {
    home.packages = with pkgs; [ nitrogen ];

    xdg.configFile = mkIf (cfg.enableDevMode == false) {
      "nitrogen/bg-saved.cfg".source = toCfg "bg-saved.cfg"
        {
          xin_1 = {
            file = dotfiles.wallpapers."11.jpeg".source;
            mode = 0;
            bgcolor = " #000000";
          };
          xin_0 = {
            file = dotfiles.wallpapers."33.png".source;
            mode = 0;
            bgcolor = "#000000";
          };
        };
      "nitrogen/nitrogen.cfg".source = toCfg "nitrogen.cfg" {
        geometry = {
          posx = 286;
          posy = 112;
          sizex = 1172;
          sizey = 818;
        };
        nitrogen = {
          view = "icon";
          recurse = true;
          sort = "alpha";
          icon_caps = "false";
          dirs = dotfiles.wallpapers.source;
        };
      };
    };
  };
}
