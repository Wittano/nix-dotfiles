{ pkgs, lib, unstable, secretDir, ... }:
with lib;
with lib.my;
let
  mkDesktopApp = config: dotfiles: name: desktopName: import (./../modules/desktop/submodules + "/${name}.nix") {
    inherit pkgs dotfiles config unstable lib desktopName secretDir;
  };
in
{
  mkDesktopModule =
    { name
    , config
    , isDevMode
    , dotfiles
    , hostname
    , autostart ? [ ]
    , apps ? [ ]
    , mutableSources ? { }
    , extraConfig ? { }
    , enableSessionTarget ? true
    , installAutostartFile ? true
    }:
    let
      cfg = config.modules.desktop.${name};
      self = modules.desktop.${name};

      desktopApps =
        let
          appsList = builtins.map (appName: mkDesktopApp config dotfiles appName name) (apps ++ [ "general" ]);
        in
        builtins.filter
          (app:
            let
              hostOnlyList = app.onlyFor or [ ];
            in
            if builtins.length hostOnlyList > 0
            then builtins.any (n: n == hostname) hostOnlyList
            else true
          )
          appsList;

      desktopAppsModule = mkMerge (builtins.map (x: x.config or { }) desktopApps);

      # THX hyprland configuration from home-manager. It isn't your code. OUR CODE
      activationSession =
        let
          variables = builtins.concatStringsSep " "
            [
              "DISPLAY"
              "XDG_CURRENT_DESKTOP"
            ];
        in
        pkgs.writeShellScript "autostart.sh" ''
          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd ${variables}

          systemctl --user stop ${desktopSessionTarget}.target
          systemctl --user start ${desktopSessionTarget}.target
        '';
      desktopSessionTarget = "${name}-session";
      sessionTargetModule = mkIf enableSessionTarget {
        systemd.user.targets."${desktopSessionTarget}" = {
          after = [ "graphical-session-pre.target" ];
          wants = [ "graphical-session-pre.target" ];
          bindsTo = [ "graphical-session.target" ];
        };

        home-manager.users.wittano.xdg.configFile = mkIf installAutostartFile {
          "autostart.sh".source = activationSession;
        };
      };

      autostartModule =
        let
          appsAutostart = lists.flatten (builtins.map (x: x.autostart or [ ]) desktopApps);
          cmds = appsAutostart ++ autostart;

          mkAutostartService = action:
            let
              serviceName = "${action.name}-autostart";

              nixPkgs = action.pkgs or pkgs;
              basicTools = with nixPkgs; [ coreutils toybox xdg-utils ];
              runtimeLibs = with nixPkgs; [
                alsa-lib
                at-spi2-atk
                at-spi2-core
                atk
                cairo
                cups
                curlWithGnuTls
                dbus
                expat
                ffmpeg_4
                fontconfig
                freetype
                gdk-pixbuf
                glib
                gtk3
                harfbuzz
                libayatana-appindicator
                libdbusmenu
                libdrm
                libgcrypt
                libGL
                libnotify
                libpng
                libpulseaudio
                libxkbcommon
                mesa
                nss_latest
                pango
                stdenv.cc.cc
                systemd
                xorg.libICE
                xorg.libSM
                xorg.libX11
                xorg.libxcb
                xorg.libXcomposite
                xorg.libXcursor
                xorg.libXdamage
                xorg.libXext
                xorg.libXfixes
                xorg.libXi
                xorg.libXrandr
                xorg.libXrender
                xorg.libXScrnSaver
                xorg.libxshmfence
                xorg.libXtst
                zlib
              ];
            in
            {
              home-manager.users.wittano.programs.fish.shellAliases.${serviceName} =
                "systemctl --user restart ${serviceName}.service";

              systemd.user.services.${serviceName} = {
                description = "Start ${serviceName} on ${name} autostart";
                bindsTo = [ "${desktopSessionTarget}.target" ];
                path = action.path ++ basicTools;
                environment.LD_LIBRARY_PATH = strings.makeLibraryPath runtimeLibs;

                serviceConfig.StandardOutput = "journal";

                wantedBy = [ "${desktopSessionTarget}.target" ];
                script = action.script;
              };
            };
        in
        mkMerge (builtins.map mkAutostartService cmds);

      mutableSourceFiles =
        let
          mutableAppsSources = lists.foldr
            (next: prev: prev // (next.mutableSources  or { }))
            { }
            desktopApps;
        in
        link.mkMutableLinks {
          inherit config isDevMode;
          paths = mutableAppsSources // mutableSources;
        };

      extraConfigModule =
        if builtins.typeOf extraConfig == "lambda"
        then extraConfig { inherit self cfg isDevMode; activationPath = activationSession; }
        else extraConfig;

      moduleChecker = {
        assertions = [
          {
            assertion = builtins.typeOf extraConfigModule == "set";
            message = "extraConfigFunc must return set of configuration";
          }
        ];
      };

      modules = [
        autostartModule
        mutableSourceFiles
        moduleChecker
        extraConfigModule
        desktopAppsModule
        sessionTargetModule
      ];
    in
    {
      options.modules.desktop.${name} = {
        enable = mkEnableOption "Enable ${name} desktop";
      };

      config = mkIf (cfg.enable) (mkMerge modules);
    };
}
