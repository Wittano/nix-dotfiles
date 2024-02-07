{ writeScriptBin
, findutils
, file
, gnugrep
, coreutils
, patchelf
, glibc
}: writeScriptBin "patcherDir" ''
  #/usr/bin/env bash

  programs=$(${findutils}/bin/find $1 -type f -perm /u=x -exec ${file}/bin/file --mime-type {} \; | ${gnugrep}/bin/grep -E "application/(x-executable)|(x-pie-executable)" | ${coreutils}/bin/cut -d ':' -f 1)

  if [ -z $programs ]; then
    ${coreutils}/bin/echo "Nothing changes"
    exit
  fi

  for p in $programs; do
    ${coreutils}/bin/echo "Patch progam $p"
    ${patchelf}/bin/patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 "$p"
  done
''
