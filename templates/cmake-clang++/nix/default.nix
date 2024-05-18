{ cmake
, clangStdenv
, gnumake
}: clangStdenv rec {
  nativebuildInputs = [
    cmake
    gnumake
  ];

  name = "cmake++";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin

    cp ${name} $out/bin
  '';
}
