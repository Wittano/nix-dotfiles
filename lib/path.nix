{ lib, ... }: {
  getConfigFile = file:
    let path = (builtins.path { path = ./../.config; }) + "/${file}";
    in if builtins.isPath path then path else builtins.toPath path;
}
