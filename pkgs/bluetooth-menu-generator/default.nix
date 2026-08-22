{
  writeShellApplication,
  busybox,
  bluez,
  ...
}:
writeShellApplication {
  name = "bluetooth-menu-generator";
  runtimeInputs = [
    busybox
    bluez
  ];
  text = builtins.readFile ./bluetooth-menu-generator.sh;
}
