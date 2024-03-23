{ config, ... }: {
  assertions = [{
    assertion = !config.networking.networkmanager.enable;
    message =
      "NetworkManager cannot be enable, causes problem with spotify interent connection";
  }];

  networking.nameservers = [ "8.8.4.4" "8.8.8.8" "1.1.1.1" ];

}
