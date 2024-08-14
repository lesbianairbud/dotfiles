#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

PS1='╔═ [\w]\n╚════║ '

(wal -i Pictures/Special/"Creature City Wallpaper.jpg")
clear

alias clock='tty-clock -Dc'
alias sl='ls'
alias why='nano ~/.config/hypr/hyprland.conf'
alias conf='cd ~/.config'
alias etc='cd /etc'
