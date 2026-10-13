{
  wget,
  zim-tools,
  toybox,
  writeShellApplication,
  fetchFromGitHub,
  imagemagick,
}:
writeShellApplication {
  name = "wget-2-zim";
  runtimeInputs = [
    wget
    zim-tools
    toybox
    imagemagick
  ];
  bashOptions = [
  ];
  excludeShellChecks = [
    "SC1087"
    "SC2199"
    "SC2242"
    "SC2076"
    "SC2215"
    "SC2086"
    "SC2001"
    "SC2006"
  ];
  text =
    let
      soruce = fetchFromGitHub {
        repo = "wget-2-zim";
        owner = "ballerburg9005";
        rev = "9d0a1fe71ca5d6c33cf1d76c4608728e870775f2";
        sha256 = "sha256-Qeg1WptApYyDvg4KaHYrLd3Pkw9xc8kqRvdCNO/KwJk=";
      };
    in
    builtins.readFile "${soruce}/wget-2-zim.sh";
}
