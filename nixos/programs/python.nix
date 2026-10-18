{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.python;

  pythonPackages = pyPkgs: packages: map (x: pyPkgs."${x}") packages;

  python = pkgs.python3.withPackages (pyPkgs: (pythonPackages pyPkgs cfg.pythonPackages));
in
{
  options.programs.python = {
    packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "list of additional packages as a external dependecies for python";
    };

    pythonPackages = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "list of additional packages to python";
    };
  };

  config = {
    environment.systemPackages = [
      python
    ]
    ++ cfg.packages;
  };
}
