{ lib, stdenv, fetchFromGitea }: stdenv.mkDerivation {
  name = "nixos-blur-plymouth";

  src = fetchFromGitea {
    domain = "git.gurkan.in";
    owner = "gurkan";
    repo = "nixos-blur-plymouth";
    rev = "ea75b51a1f04aa914647a2929eab6bbe595bcfc0";
    sha256 = "sha256-BSmh+Gy3yJMA4RoJ0uaQ/WsYBs+Txr6K3cAQjf+yM5Y=";
  };

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/nixos-blur
    
    cp -r ./nixos-blur/* $out/share/plymouth/themes/nixos-blur
    
    chmod +x $out/share/plymouth/themes/nixos-blur/nixos-blur.plymouth
    chmod +x $out/share/plymouth/themes/nixos-blur/nixos-blur.script
  '';

  meta = with lib; {
    homepage = "https://git.gurkan.in/gurkan/nixos-blur-plymouth";
    description = "Blue plymouth theme created by gurkan";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Wittano ];
    platforms = platforms.linux;
  };
}
