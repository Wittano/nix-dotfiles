{ pkgs, lib, config, home-manager, ... }:
with lib;
with builtins;
let
  cfg = config.modules.services.kubernetes;
  ipAddress = (head config.networking.interfaces.eno1.ipv4.addresses).address;
  certFile = "";
  apiServerPort = 6443;
in
{
  options = {
    modules.services.kubernetes = {
      enable = mkEnableOption "Enable master node of kubernetes on local machine";
    };
  };

  config = mkIf (cfg.enable) {
    home-manager.users.wittano = {
      programs.fish = {
        shellAbbrs = {
          kctl = "sudo kubectl --kubeconfig ~/.kube/config";
          kadm = "sudo kubeadm --kubeconfig ~/.kube/config";
        };
        shellAliases = {
          ktokendel = "sudo kubeadm --kubeconfig ~/.kube/config token list | awk '{print $1}' | grep -E '^([a-z0-9]{6})\\.([a-z0-9]{16})$' | xargs sudo kubeadm --kubeconfig ~/.kube/config token delete";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ apiServerPort ];

    users.users.wittano.extraGroups = [ "kubernetes" ];

    services.kubernetes = {
      roles = [ "master" ];
      masterAddress = ipAddress;
      apiserverAddress = "https://${ipAddress}:${toString apiServerPort}";
      easyCerts = true;
      apiserver = {
        securePort = apiServerPort;
        advertiseAddress = ipAddress;
        extraOpts = "--enable-bootstrap-token-auth=true";
      };
      controllerManager.extraOpts = "--controllers=*,bootstrapsigner,tokencleaner";

      # use coredns
      addons.dns.enable = true;

      # needed if you use swap
      kubelet.extraOpts = "--fail-swap-on=false";
    };
  };
}

