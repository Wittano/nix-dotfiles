function aliases
    alias scs='sudo systemctl status'
    alias scst='sudo systemctl stop'
    alias scsta='sudo systemctl start'
    alias sce='sudo systemctl enable --now'
    alias scd='sudo systemctl disable --now'
    alias scr='sudo systemctl restart'
    alias sdb='systemd-analyze blame'
end

if test -n (pgrep systemd | grep -E '^1$')
    aliases
end
