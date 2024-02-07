if command -vq libvirtd; and virsh list --all | grep -q win10
    alias vw='sudo virsh start win10'
    alias vwl='sudo vim /var/log/libvirt/qemu/win10.log'
end

if not test -f $HOME/.local/bin/vm
    alias vm='bash $HOME/projects/config/system/scripts/select-vagrant-vm.sh'
end
