function aliases
    alias xq='xbps-query -R'
    alias xi='sudo xbps-install -S'
    alias xiu='sudo xbps-install -Su'
    alias xr='sudo xbps-remove'
    alias xro='sudo xbps-remove -Oo'
end

if grep -q Void /etc/os-release
    aliases
end