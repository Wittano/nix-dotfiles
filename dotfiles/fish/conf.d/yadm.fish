function aliases
    alias yaa="yadm add"
	alias yac="yadm commit"
	alias yas="yadm status"
	alias yapush="yadm push origin main"
	alias yapull="yadm pull origin main"
	alias yad="yadm diff"
end

if command -vq yadm
    aliases
end