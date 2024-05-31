{ mkShell
, nixpkgs-fmt
, nil
, shellcheck
, shfmt
, lib
, nixos-rebuild
, writeShellApplication
, ...
}:
with lib;
let
  desktops = trivial.pipe ./../modules/desktop/wm [
    builtins.readDir
    builtins.attrNames
    (builtins.map (x: strings.removeSuffix ".nix" x))
  ];
  hosts = trivial.pipe ./../hosts [
    builtins.readDir
    builtins.attrNames
  ];
  confs = lists.flatten (builtins.map (host: builtins.map (desktop: "${host}-${desktop}") desktops) hosts);
  allConfigs = confs ++ builtins.map (x: "${x}-dev") confs;

  tryCommands = builtins.map
    (x: writeShellApplication {
      name = "try-${x}";
      runtimeInputs = [ nixos-rebuild ];
      text = "nixos-rebuild dry-build --flake .#${x} --show-trace";
    })
    allConfigs;
in
mkShell {
  nativeBuildInputs = [
    # Nix
    nixpkgs-fmt
    nil

    # Bash
    shellcheck
    shfmt
  ] ++ tryCommands;
}
