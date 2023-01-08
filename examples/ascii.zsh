# Name: Ascii
# Description: A prompt using only ASCII characters.

ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"

ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}^"
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}v"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}^"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}o"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}+"
ZSH_THEME_GIT_PROMPT_UNTRACKED=".."
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}$"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}>"

PROMPT='%B%40<..<%~%b$(gitprompt)'
PROMPT+='%(?.%(!.%F{yellow}.%F{green})>%f.%F{red}>%f) '
RPROMPT=''
