{ unstable ? import <nixpkgs> { } }:
let
  testGithubActions = unstable.writeShellApplication
    {
      name = "testGithubActions";
      runtimeInputs = with unstable; [ coreutils docker act ];
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
  testSddmTheme = unstable.writeShellApplication
    {
      name = "testSddmTheme";
      runtimeInputs =
        let
          gstreamerDeps = with unstable.gst_all_1; [
            gstreamer
            gst-plugins-ugly
            gst-plugins-bad
            gst-plugins-good
            gst-plugins-base
            gst-libav
          ];
          plasmaDeps = with unstable.libsForQt5; [
            plasma-framework
            plasma-workspace
          ];
          qt5Deps = with unstable.libsForQt5.qt5; [
            qtgraphicaleffects
            qtquickcontrols2
            qtbase
            qtsvg
            qtmultimedia
            unstable.libsForQt5.phonon-backend-gstreamer
          ];
        in
        (with unstable; [ coreutils sddm nix ]) ++ qt5Deps ++ plasmaDeps ++ gstreamerDeps;
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

  nixDeps = (unstable.callPackage ./default.nix { }).nativeBuildInputs;
in
unstable.mkShell {
  buildInputs = [
    testGithubActions
    testSddmTheme
  ] ++ nixDeps;
}
