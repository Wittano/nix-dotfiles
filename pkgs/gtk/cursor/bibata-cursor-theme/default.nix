{ lib
, stdenv
, fetchurl
, gnutar
}: stdenv.mkDerivation rec {
  name = "bibata-ice-cursor";

  src = fetchurl {
    url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.5/Bibata-Modern-Ice.tar.xz";
    sha256 = "sha256-PSoqQgD9WgpyDp58ekOj6uAcvNG6FEStZgPc0GmnIyk=";
  };

  nativeBuildInputs = [ gnutar ];

  buildPhase = ''
    tar xf $src
  '';

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r ./Bibata-* $out/share/icons
  '';

  meta = with lib; {
    homepage = "https://github.com/ful1e5/Bibata_Cursor";
    description = "Open source, compact, and material designed cursor set.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}
