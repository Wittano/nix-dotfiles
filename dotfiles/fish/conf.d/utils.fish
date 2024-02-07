alias fc="$EDITOR $HOME/.config/fish"
alias xc="xprop | grep CLASS | tail -n 1 | cut -f 4 -d ' ' | sed 's/\"//g'"

if command -vq youtube-dl
    alias yta="youtube-dl -x --audio-format mp3 -o '%(title)s.%(ext)s' --prefer-ffmpeg"
end
