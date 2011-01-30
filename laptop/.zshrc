autoload -U compinit
compinit

# source external configuration files:
for i in ${XDG_CONFIG_DIR}/zsh/main/{options,exports,aliases,functions}; do
	. ${XDG_CONFIG_HOME}$i || {print $i: no suck file && setopt cshjunkieloop warncreateglobal}
done

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

	export PROMPT=$'%B%F{blue}┌─[ %F{white}%n%F{blue}@%F{white}%m %F{blue}]──────( ${cwdcolour}${cwdname} %F{blue})\n└─| $(prompt_git_info) %(0?.%F{green}.%F{red})${amiroot}%b '
	export RPROMPT=$''
}
