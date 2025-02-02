#!/bin/sh
export ZDOTDIR=$HOME/.config/zsh

setopt appendhistory

# some useful options (man zshoptions)
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef		# Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')

# beeping is annoying
unsetopt BEEP

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# completions
zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select
zmodload zsh/complist
# compinit
_comp_options+=(globdots)		# Include hidden files.

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Colors
autoload -Uz colors && colors

# Useful Functions
source "$ZDOTDIR/zsh-functions"

# Normal files to source
zsh_add_file "zsh-exports"
# zsh_add_file "zsh-vim-mode"
zsh_add_file "zsh-aliases"
zsh_add_file "zsh-prompt"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"

## Syntax Highlighting Styles
# ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=blue,underline
# ZSH_HIGHLIGHT_STYLES[precommand]=fg=blue,underline
# ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue

# File manager
# Use ranger to switch directories and bind it to ctrl-o
rangercd () {
    tmp="$(mktemp)"
    ranger --choosedir="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && z "$dir"
    fi
}
# zle -N rangercd
# cd $(find . -type d -print | fzf)

# Keybindings
# bindkey "^r" "eval cd \$(fzf | dirs -p)"
bindkey -s '^o' "rangercd^M"
bindkey "^k" up-line-or-beginning-search # Up
bindkey "^j" down-line-or-beginning-search # Down
bindkey "^l" forward-char
bindkey "^h" backward-char
# bindkey "^L" clear-screen
# bindkey -s "^c" "\e"
# bindkey "^e" vi-cmd-mode

# FZF, Completions
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# [ -f $ZDOTDIR/completion/_fnm ] && fpath+="$ZDOTDIR/completion/"

# Edit line in vim with ctrl+e
# autoload edit-command-line; zle -N edit-command-line

# Environment variables
export EDITOR="nvim"

set -o autopushd
eval "$(fnm env --use-on-cd)"
#
# # pnpm
# export PNPM_HOME="/Users/mxs/Library/pnpm"
# export PATH="$PNPM_HOME:$PATH"
# # pnpm end

export GPG_TTY=$(tty)

# #compdef gt
# ###-begin-gt-completions-###
# #
# # yargs command completion script
# #
# # Installation: gt completion >> ~/.zshrc
# #    or gt completion >> ~/.zprofile on OSX.
# #
# _gt_yargs_completions()
# {
#   local reply
#   local si=$IFS
#   IFS=$'
# ' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
#   IFS=$si
#   _describe 'values' reply
# }
# compdef _gt_yargs_completions gt
# ###-end-gt-completions-###

