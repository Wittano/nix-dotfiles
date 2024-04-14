{ stdenvNoCC
, lib
, fetchFromGitHub
, theme ? "Dr.Ratio"
}:

assert builtins.any (x: x == theme) [
  "Acheron"
  "Argenti"
  "BlackSwan"
  "Dr.Ratio"
  "Hanya"
  "Huohuo"
  "Luocha"
  "RuanMei"
  "Sparkle"
  "Acheron_cn"
  "Argenti_cn"
  "BlackSwan_cn"
  "Dr.Ratio_cn"
  "Hanya_cn"
  "Huohuo_cn"
  "Luocha_cn"
  "RuanMei_cn"
  "Sparkle_cn"
];

stdenvNoCC.mkDerivation {
  name = "StarRailGrubThemes";

  src = fetchFromGitHub {
    owner = "voidlhf";
    repo = "StarRailGrubThemes";
    rev = "41a004ca19dc52bc916227c953197ec11097e1fd";
    sha256 = "sha256-lcZ21QViH+cW6G1g/KpJwo9ZfWNm5+fZnpDELDrgCyY=";
  };

  installPhase = "cp -r ./assets/themes/${theme} $out";

  meta = with lib; {
    homepage = "https://github.com/voidlhf/StarRailGrubThemes";
    description = "A pack of GRUB2 themes for Honkai: Star Rail";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}

