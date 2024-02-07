function aliases
    alias di='sudo dnf install'
	alias dup='sudo dnf update --refresh'
	alias dl='sudo dnf list'
	alias ds='dnf search'
	alias dli='sudo dnf list --installed'
	alias dar='sudo dnf autoremove'
	alias drm='sudo dnf remove'
end

if grep -q Fedora /etc/os-release
    aliases
end
