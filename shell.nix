{ mkShell
, nixpkgs-fmt
, nil
, shellcheck
, shfmt
, lib
, writeShellApplication
, nh
, python3
, pipenv
, coreutils
, docker
, act
, haskell-language-server
, haskellPackages
, statix
, openssl
, mypy
, ...
}:
with lib;
let
  testGithubActions = writeShellApplication
    {
      name = "testGithubActions";
      runtimeInputs = [ coreutils docker act ];
      text = ''
        function stop_docker {
          CONTAINER_IDS=$(docker ps | tail -n +2)
          if [ -n "$CONTAINER_IDS" ]; then
            echo "Stopping and cleaning docker from act staff"
            echo "$CONTAINER_IDS" | cut -f 1 -d " " | tail -n +2 | xargs docker stop > /dev/null
            echo "$CONTAINER_IDS" | xargs docker rm > /dev/null
          fi
        }
        trap stop_docker SIGINT
        act --use-gitignore -q --rm -W "$NIX_DOTFILES/.github/workflows" -C "$NIX_DOTFILES"
        stop_docker
      '';
    };
  xmonadDevDeps = haskellPackages.ghcWithPackages (pkgs: with pkgs; [
    xmonad
    xmonad-contrib
    xmonad-extras
    xmobar
    cabal-install
  ]);

  pythonPackages = python3.withPackages (pkgs: with pkgs; [
    mypy
    qtile
  ]);
in
mkShell {
  nativeBuildInputs = [
    # Nix
    nixpkgs-fmt
    nil
    nh
    statix

    # Bash
    shellcheck
    shfmt

    # Desktop
    testGithubActions

    # Python
    pythonPackages
    pipenv
    mypy

    # Haskell deps
    haskell-language-server

    # Xmonad
    xmonadDevDeps

    # Security
    openssl
  ];
}
