{ mkShell
, dotnetCorePackages
, nixd
, nixpkgs-fmt
, callPackage
, writeShellApplication
, coreutils
, toybox
, patchelf
, glibc
, ell
, fontconfig
, libmd
, lib
, libglvnd
, xorg
}:
with lib;
let
  sdk = dotnetCorePackages.dotnet_8.sdk;

  fetchDeps = (callPackage ./default.nix { }).fetch-deps;
  updateDeps = writeShellApplication {
    name = "updateDeps";
    runtimeInputs = [ coreutils toybox ];
    text = ''
      DEPS_NAME=./deps.nix
      if [ -f "$DEPS_NAME" ]; then
        rm "$DEPS_NAME"
      fi

      touch "$DEPS_NAME"

      ${fetchDeps} -k "$DEPS_NAME"
    '';

    fixSkiaLib = writeShellApplication {
      name = "fixSkiaLib";
      runtimeInputs = [ coreutils toybox patchelf ];
      text =
        let
          rpath = lib.strings.makeLibraryPath [ glibc ell fontconfig libmd ];
        in
        ''
          libSkiaLibs=$(find "$HOME/.nuget" -type f -iname 'libSkiaSharp.so')

          for f in $libSkiaLibs; do
            patchelf --set-rpath "${rpath}" "$f" && echo "Patched $f"
          done
        '';
    };
  };
in
mkShell {
  nativeBuildInputs = [
    # Nix
    nixpkgs-fmt
    nixd

    # Custom scripts
    updateDeps
    fixSkiaLib

    # Dotnet
    sdk
  ];

  LD_LIBRARY_PATH = strings.makeLibraryPath (with xorg; [ libX11 libICE libSM libglvnd fontconfig ]);
  DOTNET_ROOT = builtins.toString sdk;

  shellHook = ''
    # Disable telemetry
    export DOTNET_CLI_TELEMETRY_OPTOUT="0";
  '';
}
