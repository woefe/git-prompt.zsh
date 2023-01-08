#!/usr/bin/env bash

if [[ $1 = "--readme" ]]; then
    for example in examples/*.zsh; do
        heading=$(sed -n '/^# Name: /p' "$example")
        heading=${heading##\# Name: }

        description=$(sed -En '/^# Description:/,/(^# [^ ]|^$)/p' "$example")
        description=${description##\# Description:}
        description=$(echo "$description" | sed -E 's/^#? *//')

        echo "### $heading"
        echo "$description"
        echo
        echo "Load this example: \`source $example\`"
        echo
        echo '```'
        zsh -f -c "export ZSH_GIT_PROMPT_NO_ASYNC=1; source git-prompt.zsh; source $example; print -P \"\$PROMPT       \$RPROMPT\"" 2> /dev/null | sed 's/\x1B\[[0-9;]*[JKmsu]//g'
        echo '```'
        echo
        echo
    done
    exit
fi


for example in examples/*.zsh; do
    echo "$example":
    zsh -f -c "export ZSH_GIT_PROMPT_NO_ASYNC=1; source git-prompt.zsh; source $example; print -P \"\$PROMPT       \$RPROMPT\"" 2> /dev/null
    echo
    echo
done
