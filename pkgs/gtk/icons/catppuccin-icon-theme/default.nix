{ lib
, gtk3
, gtk-engine-murrine
, stdenv
, pkgs
, fetchFromGitHub
, gnome-themes-extra ? pkgs.gnome.gnome-themes-extra
}: stdenv.mkDerivation {
  name = "catppuccin-gtk-icon-theme";

  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Catppuccin-GTK-Theme";
    rev = "b8cffe7583876e17cc4558f32d17a072fa04ea9f";
    sha256 = "sha256-wJnbXXWKX0mcqRYyE1Vs4CrgWXTwfk3kRC2IhKqQ0RI=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ gtk-engine-murrine gnome-themes-extra ];

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r ./icons/* $out/share/icons

    gtk-update-icon-cache $out/share/icons/*
  '';

  meta = with lib; {
    homepage = "https://github.com/ljmill/catppuccin-icons";
    description = "Cattpucin GTK icon theme create by Fausto-Korpsvart";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}
