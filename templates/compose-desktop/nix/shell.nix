{ mkShell
, gradle
, writeShellApplication
, lib
, patchelf
, xorg
, glibc
, libglvnd
, fontconfig
, temurin-bin-17
}:
with lib;
let
  rpath = strings.makeLibraryPath [ xorg.libX11 glibc libglvnd fontconfig ];
  fixSkiko = writeShellApplication {
    name = "fixSkiko";
    runtimeInputs = [ patchelf ];
    text = ''
      for f in $(find $HOME/.skiko -iname libskiko-linux-x64.so); do
        patchelf --set-rpath "${rpath}" "$f" && echo "Patched $f"
      done
    '';
  };
in
mkShell {
  nativebuildInputs = [
    # Nix
    nixpkgs-fmt
    nixd

    # Kotlin
    gradle
    temurin-bin-17
    fixSkiko
  ];

  JAVA_HOME = builtins.toString temurin-bin-17;
}
