{ buildGoModule }: {
  name = "{{_file_name_}}";

  src = ./.;

  # TODO Replace vendor256
  vendor256 = "sha256-000000000000000000000000000";

  meta = with lib; {
    homepage = "https://github.com/Wittano/{{_file_name_}}";
    description = "Description";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}
