{ lib, stdenv, pkgs }: stdenv.mkDerivation rec {
  name = "switch-off";

  src = ./scripts;

  outputs = [ "out" ];

  buildInputs = with pkgs; [ bash rofi ];

  installPhase = ''
    mkdir -p $out/bin

    cp ./switch-off.sh $out/bin/switch-off

    chmod +x $out/bin/switch-off
  '';

  meta = with lib; {
    description = "Bash script to turn off Qtile desktop";
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}
