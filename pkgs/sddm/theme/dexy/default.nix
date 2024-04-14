{ lib
, pkgs
, stdenv
, fetchFromGitHub
}: stdenv.mkDerivation {
  name = "dexy-sddm-theme";

  src = fetchFromGitHub {
    owner = "L4ki";
    repo = "Dexy-Plasma-Themes";
    rev = "285c928eedecbc438013396292dfd346b73082e7";
    sha256 = "sha256-nx1xNdbbP1slN4Zm/gFg8m8oCLUOnZDZiLOucY2C5d8=";
  };

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r ./Dexy-Color-SDDM $out/share/sddm/themes/dexy
  '';

  meta = with lib; {
    homepage = "https://github.com/L4ki/Dexy-Plasma-Themes";
    description = "Dexy SDDM Theme create by L4ki";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}
