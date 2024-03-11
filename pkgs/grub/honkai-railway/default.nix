{ stdenvNoCC
, lib
, fetchFromGitHub
, name ? "Dr.Ratio"
}:
stdenvNoCC.mkDerivation {
  name = "StarRailGrubThemes";
  src = fetchFromGitHub {
    owner = "voidlhf";
    repo = "StarRailGrubThemes";
    rev = "b3634c646556bb14d82e04233c63afffd9235420";
    sha256 = "sha256-lcZ21QViH+cW6G1g/KpJwo9ZfWNm5+fZnpDELDrgCyY=";
  };

  installPhase = /*bash*/ ''
    if [ "${name}" == "*" ]; then
      echo "StarRailGrubThemes doesn't allow to copy all themes at the same time"
      exit 1
    fi

    cp -r ./assets/themes/${name} $out
  '';

  meta = with lib; {
    homepage = "https://github.com/voidlhf/StarRailGrubThemes";
    description = "A pack of GRUB2 themes for Honkai: Star Rail";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}

