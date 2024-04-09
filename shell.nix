{ pkgs ? import <nixpkgs> { } }:
let
  testGithubActions = pkgs.writeShellApplication
    {
      name = "testGithubActions";
      runtimeInputs = with pkgs; [ coreutils docker act ];
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
  testSddmTheme = pkgs.writeShellApplication
    {
      name = "testSddmTheme";
      runtimeInputs =
        let
          gstreamerDeps = with pkgs.gst_all_1; [
            gstreamer
            gst-plugins-ugly
            gst-plugins-bad
            gst-plugins-good
            gst-plugins-base
            gst-libav
          ];
          plasmaDeps = with pkgs.libsForQt5; [
            plasma-framework
            plasma-workspace
          ];
          qt5Deps = with pkgs.libsForQt5.qt5; [
            qtgraphicaleffects
            qtquickcontrols2
            qtbase
            qtsvg
            qtmultimedia
            pkgs.libsForQt5.phonon-backend-gstreamer
          ];
        in
        (with pkgs; [ coreutils sddm nix ]) ++ qt5Deps ++ plasmaDeps ++ gstreamerDeps;
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
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # For Qtile
    python311Packages.qtile
    python311Packages.mypy

    # Python
    python311Packages.yapf # Python Formatter
    python311Packages.isort # Python Refactor
    isort
    vscode-extensions.ms-python.vscode-pylance # Python LSP

    # Nix
    nixpkgs-fmt
    nixd

    # Bash
    shellcheck
    shfmt

    # Github actions
    act
    testGithubActions
  ];
}
