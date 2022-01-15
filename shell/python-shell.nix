with import <nixpkgs> { };
with python39Packages;
mkShell {

  buildInputs = [
    python39Full
    python39Packages.virtualenv
    python39Packages.pip
    python39Packages.setuptools
    python.pkgs.venvShellHook
  ];

  shellHook = ''
    virtualenv --no-setuptools venv
    export PATH=$PWD/venv/bin:$PATH
    export PYTHONPATH=venv/lib/python3.9/site-packages/:$PYTHONPATH
  '';

  postShellHook = ''
    ln -sf PYTHONPATH/* ${virtualenv}/lib/python3.9/site-packages
  '';
}
