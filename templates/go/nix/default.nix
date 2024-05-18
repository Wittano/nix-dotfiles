{ lib, buildGoModule }:
with lib;
buildGoModule {
  pname = "go-app";
  src = ./.;

  vendorSha256 = fakeSha256;
}
