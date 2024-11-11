{ lib, ... }:
with lib;
{
  mkLinks = links:
    let
      mkScript = src: dest: ''
        DIR=$(dirname ${dest})

        mkdir -p "$DIR"

        if [ -e "${dest}" ]; then
          unlink ${dest} || rm ${dest}
        fi

        ln -s ${src} ${dest}
      '';
    in
    trivial.pipe links [
      (builtins.filter (x: x.active or false))
      (builtins.map (x: mkScript x.src x.dest))
      (builtins.concatStringsSep "\n\n")
    ];
}
