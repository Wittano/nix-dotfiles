{ config, pkgs, ... }: {
  services.boinc = {
    enable = true;
    extraEnvPackages = with pkgs; [ ocl-icd linuxPackages.nvidia_x11 ];
    allowRemoteGuiRpc = true;
  };
}
