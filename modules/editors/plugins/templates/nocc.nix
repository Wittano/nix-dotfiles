{ stdenvNoCC }: stdenvNoCC.mkDerivation {
  name = "{{_file_name_}}";
  src = ./.;

  buildInputs = [ ];

  buildPhase = ''
  '';

  installPhase = ''
  '';

  meta = with lib; {
    homepage = "https://github.com/Wittano/{{_file_name_}}";
    description = "Description";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}
