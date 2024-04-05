{
  description = "Wittano NixOS configuration";

  nixConfig = {
    trusted-substituters = [
      "https://ezkea.cachix.org"
      "https://wittano-nix-repo.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
      "https://nix-gaming.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      "wittano-nix-repo.cachix.org-1:SqjGwMsbzVQOXhbS90DXFC7AoGH99dzPy8zixK3cyt0="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    filebot.url = "github:Wittano/filebot";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    agenix.url = "github:ryantm/agenix";
    nixvim = {
      url = "github:nix-community/nixvim?ref=nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      mkPkgs = p:
        import p {
          inherit system;

          config.allowUnfree = true;
        };

      pkgs = mkPkgs inputs.nixpkgs;
      unstable = mkPkgs inputs.nixpkgs-unstable;

      privateRepo = lib.my.pkgs.importPkgs ./pkgs;

      lib = nixpkgs.lib.extend (sefl: super: {
        hm = home-manager.lib.hm;
        my = import ./lib { inherit lib system inputs pkgs unstable privateRepo; };
      });

      templatesDirs = builtins.attrNames
        (lib.filterAttrs (n: v: v == "directory")
          (builtins.readDir ./templates));

      templates = lib.lists.forEach templatesDirs (name: {
        inherit name;

        value = {
          path = ./templates/${name};
          description = "Template for ${name}";
        };
      });
    in
    {
      lib = lib.my;

      nixosConfigurations =
        let
          inherit (lib.attrsets) mapAttrs' nameValuePair;
          inherit (lib.my.hosts) mkHost;

          hosts = builtins.readDir ./hosts;
          devHosts = mapAttrs'
            (n: v:
              let devName = "${n}-dev";
              in
              nameValuePair (devName) (mkHost {
                name = devName;
                isDevMode = true;
              }))
            hosts;
          normalHosts = builtins.mapAttrs (n: v: mkHost { name = n; }) hosts;
        in
        normalHosts // devHosts;

      devShells.${pkgs.system}.default =
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
        };

      packages.x86_64-linux = privateRepo;

      templates = builtins.listToAttrs templates;
    };
}
