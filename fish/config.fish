# vi:syntax=sh:
if status is-interactive
    # Commands to run in interactive sessions can go here
end
clear
#neofetch
pfetch
export EDITOR=/bin/fish

#aliases
alias cls=clear
alias csl=clear
alias lcs=clear
alias lsc=clear
alias scl=clear
alias slc=clear
alias nf=neofetch
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
alias cpbc='nvim ~/.config/polybar/config'
alias rmr='rm -rfI'
alias ytdl='yt-dlp'
alias xclipc='xclip -selection c'
alias fucksudo='faillock --user rewardedivan --reset'
alias rmrf='rm -rf'
alias untargz='tar -xzf'
alias untar='tar -xf'
alias gst='git status'
alias ga='git add .'
alias gp='git push'
alias cgph='xclipc ~/gph'
alias gcom='git commit -m'
alias searchf='tree / -af | grep'
# dd help: sudo dd bs=512M status=progress if=file.iso of=/dev/sdX
