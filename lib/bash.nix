_: {
  mkBashArray = list: builtins.concatStringsSep " " (builtins.map (x: "\"${x}\"") list);
}
