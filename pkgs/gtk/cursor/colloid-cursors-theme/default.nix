{ lib
, stdenv
, fetchFromGitHub
, bash
, pkgs
, inkscape
, xcursorgen ? pkgs.xorg.xcursorgen
, gtk-engine-murrine
, gnome-themes-extra ? pkgs.gnome.gnome-themes-extra
}: stdenv.mkDerivation rec {
  name = "colloid-cursors-theme";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Colloid-icon-theme";
    rev = "147dd50c99493588c2c7af72954ecc32d36a09e6";
    sha256 = "sha256-2J6LmDV/Y2+x+nK3mO+t4MnmZCbVwDLX0tDG6BmLgqo=";
  };

  nativeBuildInputs = [ bash inkscape xcursorgen ];

  propagatedBuildInputs = [ gtk-engine-murrine gnome-themes-extra ];

  buildPhase = ''
    cd ./cursors
    bash ./build.sh
  '';

  installPhase = ''
    mkdir -p $out/share/icons/${name}
    cp -r ./dist/* $out/share/icons/${name}
  '';

  meta = with lib; {
    homepage = "https://github.com/vinceliuice/Colloid-icon-theme";
    description = "Colloid GTK cursors theme create by vinceliuice";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}
