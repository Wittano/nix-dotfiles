{ lib
, SDL2
, callPackage
, alsa-lib
, appimageTools
, autoPatchelfHook
, fetchurl
, ffmpeg_4
, gamemode
, icu
, libkrb5
, lttng-ust
, makeDesktopItem
, makeWrapper
, numactl
, openssl
, stdenvNoCC
, symlinkJoin
, vulkan-loader
, pipewire_latency ? "64/48000"
, # reasonable default
  gmrun_enable ? true
, # keep this flag for compatibility
  command_prefix ? if gmrun_enable
  # won't hurt users even if they don't have it set up
  then "${gamemode}/bin/gamemoderun"
  else null
}:
let
  pname = "osu-lazer-bin";
  version = "2024.312.0";

  appimageBin = fetchurl {
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
    hash = "sha256-kWNobQXGGS2TWvPkhfheqnlbijfnxfcP36ANUeN6bW0=";
  };

  extracted = appimageTools.extract {
    inherit version;
    pname = "osu.AppImage";
    src = appimageBin;
  };
  osuLazer = stdenvNoCC.mkDerivation rec {
    inherit version pname;
    src = extracted;
    buildInputs = [
      SDL2
      alsa-lib
      ffmpeg_4
      icu
      libkrb5
      lttng-ust
      numactl
      openssl
      vulkan-loader
    ];
    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];
    autoPatchelfIgnoreMissingDeps = true;
    installPhase = ''
      runHook preInstall
      install -d $out/bin $out/lib
      install osu\!.png $out/osu.png
      cp -r usr/bin $out/lib/osu
      makeWrapper $out/lib/osu/osu\! $out/bin/osu-lazer \
        --set COMPlus_GCGen0MaxBudget "600000" \
        --set PIPEWIRE_LATENCY "${pipewire_latency}" \
        --set vblank_mode "0" \
        --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}"
      ${
        # a hack to infiltrate the command in the wrapper
        lib.optionalString (builtins.isString command_prefix) ''
          sed -i '$s:exec :exec ${command_prefix} :' $out/bin/osu-lazer
        ''
      }
      runHook postInstall
    '';
    fixupPhase = ''
      runHook preFixup
      ln -sft $out/lib/osu ${SDL2}/lib/libSDL2${stdenvNoCC.hostPlatform.extensions.sharedLibrary}
      runHook postFixup
    '';
  };
  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${osuLazer.outPath}/bin/osu-lazer %U";
    icon = "${osuLazer.outPath}/osu.png";
    comment = "A free-to-win rhythm game. Rhythm is just a *click* away!";
    desktopName = "osu!";
    categories = [ "Game" ];
    mimeTypes = [
      "application/x-osu-skin-archive"
      "application/x-osu-replay"
      "application/x-osu-beatmap-archive"
      "x-scheme-handler/osu"
    ];
  };

  osuMime = callPackage ./../osu-mime { };

in
symlinkJoin {
  name = "${pname}-${version}";
  paths = [
    osuLazer
    desktopItem
    osuMime
  ];

  meta = {
    description = "Rhythm is just a *click* away";
    longDescription = "osu-lazer extracted from the official AppImage to retain multiplayer support.";
    homepage = "https://osu.ppy.sh";
    license = with lib.licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    mainProgram = "osu-lazer";
    platforms = [ "x86_64-linux" ];
    maintainers = [ "Wittano" ];
  };
}
