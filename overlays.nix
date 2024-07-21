{ inputs, lib, ... }: with lib; with lib.my; let
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
in
{
  overlay = wittanoOverlay;

  systemOverlays = inputs.xmonad-contrib.overlays ++ [
    wittanoOverlay
    haskellPackagesOverlay
  ];
}

