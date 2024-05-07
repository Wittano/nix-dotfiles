{ lib, stdenv }: stdenv.mkDerivation {
  name = "nixos-blur-plymouth";

  src = ./nixos-blur;

  installPhase = ''
    mkdir -p $out/share/plymouth/themes/nixos-blur
    
    cp -r * $out/share/plymouth/themes/nixos-blur
    
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
