function __fish_vm_list
    find $HOME/projects/config/system -name Vagrantfile -type f | cut -d '/' -f 8
end

set -l vagrant_commands destroy start halt up ssh reload restart

for vm in (__fish_vm_list)
    complete -f -c vm -n "not __fish_seen_subcommand_from (__fish_vm_list)" -a $vm
    complete -f -c vm -n "__fish_seen_subcommand_from $vm; and not __fish_seen_subcommand_from $vagrant_commands" -a "$vagrant_commands"
end

complete -f -c vm -n "not __fish_seen_subcommand_from all" -a all
complete -f -c vm -n "__fish_seen_subcommand_from all; and not __fish_seen_subcommand_from $vagrant_commands" -a "$vagrant_commands"
