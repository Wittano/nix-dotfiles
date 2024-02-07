function aliases
    alias pra="sudo pacman -Rsn (pacman -Qdtq)"
end

if grep -q Arch /etc/os-release
    aliases
end
