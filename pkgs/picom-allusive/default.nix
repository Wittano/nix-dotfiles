{ picom, lib, fetchFromGitHub, installShellFiles, pcre2 }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "compfy";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "allusive-dev";
    repo = "compfy";
    rev = version;
    hash = "sha256-7hvzwLEG5OpJzsrYa2AaIW8X0CPyOnTLxz+rgWteNYY=";
  };

  buildInputs = [ pcre2 ] ++ oldAttrs.buildInputs;

  nativeBuildInputs = [ installShellFiles ] ++ oldAttrs.nativeBuildInputs;

  postInstall = ''
    if [ -f "$out/bin/compfy" ]; then
      mv "$out/bin/compfy" "$out/bin/picom"
    fi
  '';

  meta = (builtins.removeAttrs oldAttrs.meta [ "longDescription" ]) // {
    description = "A fork of picom featuring improved animations and other features";
    homepage = "https://github.com/allusive-dev/picom-allusive";
    license = with lib.licenses; [ mit mpl20 ];
    maintainers = with lib.maintainers; [ Wittano ];
  };
})
