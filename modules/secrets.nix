{ config, lib, pkgs, system, inputs, secretDir, ... }:
with lib;
with lib.my;
let
  secrets = builtins.readDir secretDir;
  identityPaths = trivial.pipe secrets [
    builtins.attrNames
    (builtins.filter (x: strings.hasSuffix ".age" x))
    (builtins.map (x: "/etc/ssh/${x}"))
  ];
in
{
  environment.systemPackages = [ inputs.agenix.packages."${system}".default ];
  age = {
    inherit identityPaths;
    secrets.samba = {
      file = secretDir + "/samba.age";
      owner = "root";
      group = "root";
    };
  };

  services.openssh = mkIf (!config.modules.services.ssh.enable) {
    enable = mkForce true;
    openFirewall = false;
    allowSFTP = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  system.activationScripts.backupHostKeys =
    let
      homeDir = config.home-manager.users.wittano.home.homeDirectory;
      backupDir =
        if config.modules.services.backup.enable
        then config.modules.services.backup.location
        else "${homeDir}/.ssh/backup";
      keys = builtins.map (x: x.path) config.services.openssh.hostKeys;
      keyArray = bash.mkBashArray keys;
    in
      /*bash*/ ''
      keys=(${keyArray})
      today=$(date +"%d-%b-%Y")

      moveNewerKey() {
          name=$(${pkgs.toybox}/bin/basename "$1")
          currect="${backupDir}/$name"
          newHash=$(${pkgs.toybox}/bin/sha512sum "$1" | cut -f 1 -d ' ')
          oldHash=$(${pkgs.toybox}/bin/sha512sum "$currect" | cut -f 1 -d ' ' || echo "")

          if [ "$newHash" != "$oldHash" ]; then
              echo "Backup $currect and create new key"
              if [ -f "$currect" ]; then
                mv "$currect" "${backupDir}/$today-$name"
              fi

              cp "$1" "$currect"
          fi
      }

      for p in "''${keys[@]}"; do
          moveNewerKey "$p" || echo "failed move file $p"
          moveNewerKey "$p.pub" || echo "failed move file $p.pub"
      done
    '';
}
