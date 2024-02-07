{
  description = "Kotlin Desktop Compose";

  inputs.nixpkgs.url = "nixpkgs/nixos-23.11";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      jvm = pkgs.temurin-bin-17;

      lib = pkgs.lib;

      fixSkiko =
        let
          rpath = lib.strings.makeLibraryPath (with pkgs; [ xorg.libX11 glibc libglvnd fontconfig ]);
        in
        pkgs.writeScriptBin "fixSkiko" /*bash*/ ''
          #!/usr/bin/env bash

          for f in $(find $HOME/.skiko -iname libskiko-linux-x64.so); do
            ${pkgs.patchelf}/bin/patchelf --set-rpath "${rpath}" "$f" && echo "Patched $f"
          done
        '';
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [ gradle jvm fixSkiko ];

        JAVA_HOME = "${jvm}";
      };
    };
}

