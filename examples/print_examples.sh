#!/usr/bin/env bash

tmpdir=$(mktemp -d -p /tmp git-prompt.zsh.XXXX)
projectdir=$(dirname "$(dirname "$(realpath "$0")")")
trap 'rm -rf -- "$tmpdir"' EXIT
mkdir -p "$tmpdir/workspace"

export GIT_AUTHOR_NAME="Bob"
export GIT_AUTHOR_EMAIL="bob@example.com"
export GIT_COMMITTER_NAME="Alice"
export GIT_COMMITTER_EMAIL="alice@example.com"

git clone -q https://github.com/octocat/Hello-World "$tmpdir/workspace/hello_world"
cd "$tmpdir/workspace/hello_world" || exit
export HOME=$tmpdir
touch untracked.txt
echo >> README.md
git add README.md
git commit -q -m "Update README.md"
echo >> README.md
git stash -q
git stash apply -q
git add README.md
echo >> README.md
echo >> index.html

if [[ $1 = "--readme" ]]; then
    for example in "$projectdir"/examples/*.zsh; do
        heading=$(sed -n '/^# Name: /p' "$example")
        heading=${heading##\# Name: }

        description=$(sed -En '/^# Description:/,/(^# [^ ]|^$)/p' "$example")
        description=${description##\# Description:}
        description=$(echo "$description" | sed -E 's/^#? *//')

        echo "### $heading"
        echo "$description"
        echo
        echo "Load this example: \`source ${example##"$projectdir"/}\`"
        echo
        echo '```'
        zsh -f -c "export ZSH_GIT_PROMPT_NO_ASYNC=1; source \"$projectdir/git-prompt.zsh\"; source \"$example\"; print -P \"\$PROMPT       \$RPROMPT\"" 2> /dev/null | sed 's/\x1B\[[0-9;]*[JKmsu]//g'
        echo '```'
        echo
        echo
    done
    exit
fi


for example in "$projectdir"/examples/*.zsh; do
    echo "${example##"$projectdir"/}:"
    zsh -f -c "export ZSH_GIT_PROMPT_NO_ASYNC=1; source \"$projectdir/git-prompt.zsh\"; source \"$example\"; print -P \"\$PROMPT       \$RPROMPT\"" 2> /dev/null
    echo
    echo
done
