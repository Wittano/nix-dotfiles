{ mkShell
, nixpkgs-fmt
, nil
, shellcheck
, shfmt
, lib
, writeShellApplication
, nh
, python3
, gst_all_1
, pipenv
, coreutils
, docker
, act
, libsForQt5
, sddm
, nix
, haskell-language-server
, cabal-install
, kdePackages
, haskellPackages
, statix
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
  testSddmTheme = writeShellApplication
    {
      name = "testSddmTheme";
      runtimeInputs =
        let
          gstreamerDeps = with gst_all_1; [
            gstreamer
            gst-plugins-ugly
            gst-plugins-bad
            gst-plugins-good
            gst-plugins-base
            gst-libav
          ];
          plasmaDeps = with libsForQt5; [
            plasma-framework
            plasma-workspace
            kdePackages.sddm
          ];
          qt5Deps = with libsForQt5.qt5; [
            qtgraphicaleffects
            qtquickcontrols2
            qtbase
            qtsvg
            qtmultimedia
            libsForQt5.phonon-backend-gstreamer
          ];
        in
        [ coreutils sddm nix ] ++ qt5Deps ++ plasmaDeps ++ gstreamerDeps;
      text = ''
        THEME_DIR="./pkgs/sddm/theme/$1";

        if [ ! -d "$THEME_DIR" ]; then
          echo "SDDM theme $THEME_DIR wasn't found"
          exit 1
        fi

        nix build "$NIX_DOTFILES#$1"
        sddm-greeter --test-mode --theme "$NIX_DOTFILES/result/share/sddm/themes/$1"           
      '';
    };
  xmonadDevDeps = haskellPackages.ghcWithPackages (pkgs: with pkgs; [
    xmonad
    xmonad-contrib
    xmonad-extras
    xmobar
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
    testSddmTheme

    # Python
    python3
    pipenv

    # Haskell deps
    haskell-language-server
    cabal-install

    # Xmonad
    xmonadDevDeps
  ];
}
