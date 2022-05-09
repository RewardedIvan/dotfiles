if status is-interactive
    # Commands to run in interactive sessions can go here
end
clear
neofetch | lolcat
#pfetch | lolcat
export EDITOR=/bin/nvim

#aliases
alias cls=clear
alias csl=clear
alias lcs=clear
alias lsc=clear
alias scl=clear
alias slc=clear
alias nf='neofetch | lolcat'
alias pf='pfetch | lolcat'
alias ls='exa --color always -lah'
alias lsv=/etc/ls
alias pacmanSy='sudo pacman -Sy'
alias pacmanD='sudo pacman -D'
alias pacmanQ='sudo pacman -Q'
alias pacmanR='sudo pacman -R'
alias pacmanS='sudo pacman -S'
alias pacmanT='sudo pacman -T'
alias pacmanSyu='sudo pacman -Syu'
alias lfc='source ~/.config/fish/config.fish'
alias cfc='nvim ~/.config/fish/config.fish'
alias ci3c='nvim ~/.config/i3/config'
alias cpbc='nvim ~/.config/polybar/config.ini'
alias ytdl "yt-dlp -f bestvideo+bestaudio --merge-output-format mp4" # credit: https://github.com/kiosion/dotfiles/blob/8161bfe924e8c717f04b44e92cea2af18415b628/.macos/.config/fish/config.fish
alias xclipc='xclip -selection c'
alias fucksudo='faillock --user rewardedivan --reset'
alias rmrf='rm -rfI'
alias rmrfDONTASK 'rm -rf'
alias cprf='cp -rf'
alias untargz='tar -xzf'
alias untar='tar -xf'
alias gst='git status'
alias ga='git add .'
alias gp='cghp ; git push ; xclipc ~/nothing'
alias cghp='xclipc ~/ghp'
alias gcom='git commit -m'
alias gacom='git add . && git commit -m'
alias searchf='tree / -af | grep'
alias searchfh='tree ./ -af | grep'
alias searchp='pacman -Q | grep'
alias grs='git restore --staged'
alias chmodpx='chmod +x'
alias of 'onefetch'
alias d 'dictionarycli'
# dd help: sudo dd bs=512M status=progress if=file.iso of=/dev/sdX
