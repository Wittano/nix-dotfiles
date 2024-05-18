{ mkShell, llvmPackages, cmake, gnumake, nixpkgs-fmt, nixd }: mkShell {
  nativeBuildInputs = [
    # Nix
    nixpkgs-fmt
    nixd

    # C++
    llvmPackages.libcxxClang
    cmake
    gnumake
  ];
}
