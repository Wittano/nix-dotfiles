{ lib, ... }:
let
  inherit (lib.attrsets) nameValuePair;
  inherit (lib.my.hosts) mkHost;
  inherit (lib.lists) flatten;

  hosts = builtins.attrNames (builtins.readDir ./hosts);
  desktopHosts = lib.my.string.mkNixNamesFromDir ./modules/desktop/wm;

  finalHosts = (flatten (builtins.map (x: builtins.map (d: "${x}-${d}") desktopHosts) hosts)) ++ hosts;

  devHosts = builtins.listToAttrs (builtins.map
    (n:
      let devName = "${n}-dev";
      in
      nameValuePair (devName) (mkHost {
        name = devName;
        isDevMode = true;
      }))
    finalHosts);

  normalHosts = builtins.listToAttrs (builtins.map
    (name: {
      inherit name;
      value = mkHost { inherit name; };
    })
    finalHosts);
in
normalHosts // devHosts
