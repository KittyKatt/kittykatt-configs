autoload -U compinit colors
colors
compinit

# source external configuration files:
for i in ${XDG_CONFIG_DIR}/zsh/main/{options,exports,aliases,functions}; do
	. ${XDG_CONFIG_HOME}$i || {print $i: no suck file && setopt cshjunkieloop warncreateglobal}
done

autoload zkbd
[[ ! -f ${ZDOTDIR:-$HOME}/.zkbd/$TERM ]] && zkbd
source ${ZDOTDIR:-$HOME}/.zkbd/$TERM

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

bindkey "\e[1;5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[1;5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word

# Auto-Complete ssh hosts
compdef sshfs=scp
compdef yaourt=pacman
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Autoload zsh functions.
fpath=(~/.config/zsh/functions $fpath)
autoload -U ~/.config/zsh/functions/*(:t)
 
# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
 
# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

# PROMPT=$'%B%F{blue}┌─[ %F{white}%n%F{blue}@%F{white}%m %F{blue}]──────( %F{white}%5~ %F{blue})\n└─|%F{green} %$(__git_ps1) %F{blue}>>>%b '
# RPROMPT=$'%B%F{blue}[ %F{white}%D{%m/%d/%y} %F{blue}]%b'
# RPROMPT=$''
# PROMPT=$'%B%F{blue}┌─[ %F{white}%n%F{blue}@%F{white}%m %F{blue}]──────( %F{white}%5~ %F{blue})\n└─|%F{yellow} %$(__git_ps1) %(0?.%F{green}.%F{red})%(0#.#.>>>)%b '

function precmd()
{
	cwdcolour=`[ -w "\`pwd\`" ] && echo '%F{white}' || echo "%F{red}"`
	cwdname="%3~"

	amiroot=`[ $UID != 0 ] && echo '>>>' || echo '!#'`

	export PROMPT=$'%B%{${fg[magenta]}%}┌─[ %F{white}%n%{${fg[magenta]}%}@%F{white}%m %{${fg[magenta]}%}]──────( ${cwdcolour}${cwdname} %{${fg[magenta]}%})\n└─| $(prompt_git_info) %(0?.%F{green}.%F{red})${amiroot}%b '
	export RPROMPT=$''
}
