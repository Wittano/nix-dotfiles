{ writeShellApplication
, findutils
, file
, gnugrep
, coreutils
, patchelf
, glibc
}: writeShellApplication {
  name = "patcherDir";
  runtimeInputs = [ findutils file gnugrep coreutils patchelf ];
  text = ''
    programs=$(find "$1" -type f -perm /u=x -exec file --mime-type {} \; | grep -E "application/(x-executable)|(x-pie-executable)" | cut -d ':' -f 1)

    if [ -z "$programs" ]; then
      echo "Nothing changes"
      exit
    fi

    for p in $programs; do
      echo "Patch progam $p"
      patchelf --set-interpreter ${glibc}/lib/ld-linux-x86-64.so.2 "$p"
    done
  '';
}
