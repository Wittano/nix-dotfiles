if command -q -v nvim
    set -gx EDITOR nvim

    alias vi="nvim"
    alias vc="nvim ~/.config/nvim/init.vim"
else
    alias vi="vim"
end
