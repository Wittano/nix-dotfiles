{ lib
, stdenv
, fetchgit
, pkgs
}: stdenv.mkDerivation {
  name = "suger-candy-sddm-theme";

  src = fetchgit {
    url = "https://framagit.org/MarianArlt/sddm-sugar-candy.git";
    rev = "2b72ef6c6f720fe0ffde5ea5c7c48152e02f6c4f";
    sha256 = "sha256-XggFVsEXLYklrfy1ElkIp9fkTw4wvXbyVkaVCZq4ZLU=";
  };

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r . $out/share/sddm/themes/sugar-candy
  '';

  meta = with lib; {
    homepage = "https://framagit.org/MarianArlt/sddm-sugar-candy";
    description = "Suger candy sddm theme created by Marian Arlt";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}
