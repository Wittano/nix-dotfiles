{ inputs, lib, ... }:
with lib;
with lib.my;
let
  privateRepo = pkgs.importPkgs ./pkgs;

  wittanoOverlay = _: _: privateRepo;

  haskellPackagesOverlay = final: prev: {
    haskellPackages = prev.haskellPackages.extend
      (self: super: {
        xmonad-extras = (self.callHackage "xmonad-extras" "0.17.1" { }).overrideAttrs {
          patches = [ ./patches/xmonad-extras.patch ];
        };
      });
  };
  commonInputs = with pkgs; [ libnotify coreutils ];

  packagesPatches = final: prev: {
    timeNotify = pkgs.writeShellApplication {
      name = "time-notify";
      runtimeInputs = commonInputs;
      text = ''
        notify-send -t 2000 "$(date)"
      '';
    };

    showVolume = pkgs.writeShellApplication {
      name = "show-volume";
      runtimeInputs = commonInputs;
      text = ''
        notify-send -t 2000 "Volume: $(amixer sget Master | awk -F"[][]" '/Left:/ { print $2 }')";
      '';
    };

    signal-desktop = prev.signal-desktop.overrideAttrs (oldAttrs: {
      preFixup = oldAttrs.preFixup + ''
        substituteInPlace $out/share/applications/${oldAttrs.pname}.desktop \
        --replace "$out/bin/${oldAttrs.pname}" "$out/bin/${oldAttrs.pname} --use-tray-icon"
      '';
    });

    mindustry = prev.mindustry.override {
      gradle = final.gradle_7;
    };

    jetbrains = prev.jetbrains // {
      goland = prev.jetbrains.goland.overrideAttrs (attrs: {
        postFixup = (attrs.postFixup or "") + lib.optionalString final.stdenv.isLinux ''
          if [ -f $out/goland/plugins/go-plugin/lib/dlv/linux/dlv ]; then
            rm $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
          fi

          ln -s ${final.delve}/bin/dlv $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
        '';
      });
    };
  };
in
{
  overlay = wittanoOverlay;

  systemOverlays = inputs.xmonad-contrib.overlays ++ [
    wittanoOverlay
    haskellPackagesOverlay
    packagesPatches
  ];
}

