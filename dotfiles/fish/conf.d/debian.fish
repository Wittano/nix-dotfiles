function aliases
    alias ai="sudo apt install --no-install-recommends --auto-remove --show-progress"
    alias au="sudo apt update && sudo apt upgrade"
    alias ar="sudo apt remove"
    alias ara="sudo apt autoremove"
    alias ap="sudo apt purge"
    alias as="apt search"
end

if grep -q Debian /etc/os-release
    aliases
end
