let
  samba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiRnkN7su0TgY6ELqJMxCkoePHvfT8aHqpbz3DsefiO wittano@nixos";
in
{
  "samba.age".publicKeys = [ samba ];
}
