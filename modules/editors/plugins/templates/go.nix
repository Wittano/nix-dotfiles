{ lib, buildGoModule }: {
  name = "{{_file_name_}}";

  src = ./.;

  vendor256 = lib.fakeSha256;

  meta = with lib; {
    homepage = "https://github.com/Wittano/{{_file_name_}}";
    description = "Description";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}
