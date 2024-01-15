{ pkgs, lib, config, home-manager, ... }:
with lib;
with builtins;
let
  cfg = config.modules.services.kubernetes;
in
{
  options = {
    modules.services.kubernetes = {
      enable = mkEnableOption "Enable master node of kubernetes on local machine";
    };
  };

  config = mkIf (cfg.enable) {
    home-manager.users.wittano = {
      home.packages = with pkgs; [ kubectl k9s ];
      programs.fish.shellAbbrs.kubectl = "sudo kubectl --kubeconfig ~/.kube/config";
    };

    services.kubernetes =
      let
        ipAddress = (head config.networking.interfaces.eno1.ipv4.addresses).address;
        apiServerPort = 6443;
      in
      {
        roles = [ "master" "node" ];
        masterAddress = ipAddress;
        apiserverAddress = "https://${ipAddress}:${toString apiServerPort}";
        easyCerts = true;
        apiserver = {
          securePort = apiServerPort;
          advertiseAddress = ipAddress;
        };

        # use coredns
        addons.dns.enable = true;

        # needed if you use swap
        kubelet.extraOpts = "--fail-swap-on=false";
      };
  };
}

