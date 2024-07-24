#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"

eval "$(starship init bash)"

cat ~/.cache/wal/sequences

source ~/.cache/wal/colors-tty.sh

source /etc/shell-mommy.sh

export PATH=$PATH:/home/wotthefluff/.spicetify

alias clock='tty-clock -Dc'
alias sl='ls'
alias why='nano ~/.config/hypr/hyprland.conf'
alias conf='cd ~/.config'
alias etc='cd /etc'

