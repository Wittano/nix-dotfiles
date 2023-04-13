{ ... }:
{ imports =
    [
      ./boinc.nix
      ./syncthing.nix
      ./ssh.nix
      ./redshift.nix
      ./prometheus.nix
      ./backup.nix
    ];
}
