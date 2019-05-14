<h1><img src="screenshot.svg" width="800" /></h1>

A fast, customizable, pure-shell, asynchronous Git prompt for Zsh.
It is heavily inspired by Olivier Verdier's [zsh-git-prompt](https://github.com/olivierverdier/zsh-git-prompt) and very similar to the "Informative VCS" prompt of fish shell.

## Prompt Structure
The structure of the prompt (in the default configuration) is the following:

```
[<branch_name><tracking_status>|<local_status>]
```

* `branch_name`: Name of the current branch or commit hash if HEAD is detached. When in 'detached HEAD' state, the
    `branch_name` will be prefixed with a colon `:` to indicate that it is actually a hash and not a branch name.
* `tracking_status`:
    * `↑n`: ahead of remote by `n` commits
    * `↓n`: behind remote by `n` commits
    * `↓m↑n`: branches diverged; other by `m` commits, yours by `n` commits
* `local_status`:
    * `✔`: repository is clean
    * `✖n`: there are `n` unmerged files
    * `●n`: there are `n` staged files
    * `✚n`: there are `n` unstaged and changed files
    * `…n`: there are `n` untracked files
    * `⚑n`: there are `n` entries on the stash (disabled by default)

## Installation
### Dependencies
* Git with `--porcelain=v2` support, which is available since version 2.11.0.
    You can check if your installation is compatible by executing `git status --branch --porcelain=v2` inside a Git repository.
* [awk](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html), which is most certainly pre-installed on any *nix system

### Arch Linux
Install [git-prompt.zsh](https://aur.archlinux.org/packages/git-prompt.zsh/) or [git-prompt.zsh-git](https://aur.archlinux.org/packages/git-prompt.zsh-git/) from the AUR.

### Manual installation
Clone this repo or [download git-prompt.zsh](https://raw.githubusercontent.com/woefe/zsh-git-prompt/master/git-prompt.zsh) the file.
Then source it in your `.zshrc`. For example:

```bash
mkdir -p ~/.zsh/git-prompt.zsh
curl -o ~/.zsh/git-prompt.zsh https://raw.githubusercontent.com/woefe/zsh-git-prompt/master/git-prompt.zsh
echo "source ~/.zsh/git-prompt.zsh" >> .zshrc
```

## Customization
Unlike other popular prompts this prompt does not use `promptinit`, which gives you the flexibility to build your own prompt from scratch.
Use the `gitprompt` function when building your own prompt by overriding the `PROMPT` variable in your `.zshrc`.
You can find more information on how to configure the `PROMPT` in [Zsh's online documentation](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html) or the `zshmisc` manpage, section "SIMPLE PROMPT ESCAPES".

### Examples
Some example `PROMPT` configurations are given below.

#### Default (same as in title)
```zsh
# Preview:
# ../git-prompt.zsh [master↑1|●1✚1…1] ❯❯❯

PROMPT='%B%40<..<%~ %b$(gitprompt)%(?.%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f.%F{red}❯❯❯%f) '
```

#### Multi-line prompt
```zsh
# Preview:
# ┏╸130 · ~/workspace/git-prompt.zsh · ⎇ master↑1 ‹●1✚1…1›
# ┗╸❯❯❯

ZSH_THEME_GIT_PROMPT_PREFIX="%B · %b"
ZSH_THEME_GIT_PROMPT_SUFFIX="›"
ZSH_THEME_GIT_PROMPT_SEPARATOR=" ‹"
ZSH_THEME_GIT_PROMPT_BRANCH="⎇ %{$fg_bold[cyan]%}"
PROMPT=$'┏╸%(?..%F{red}%?%f · )%B%~%b$(gitprompt)\n┗╸%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f '
```

#### [Pure](https://github.com/sindresorhus/pure) clone
```zsh
# Preview:
#
# ~/workspace/git-prompt.zsh master↑3 ✚2…1
# ❯

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_no_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_no_bold[grey]%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_no_bold[cyan]%}↓"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_no_bold[cyan]%}↑"
PROMPT=$'\n%F{blue}%~%f %F{242}$(gitprompt)%f\n%(12V.%F{242}%12v%f .)%(?.%F{magenta}.%F{red})❯%f '
```

#### Git status on the right
```zsh
# Preview:
# ~/workspace/git-prompt.zsh ≻≻≻                                ≺ master↑1|●1✚1…1

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[default]%}≺ "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
PROMPT='%B%~%b %F{blue}≻≻≻%f '
RPROMPT='$(gitprompt)'
```

### Appearance
The appearance of the prompt can be adjusted by changing the variables that start with `ZSH_THEME_GIT_PROMPT_`.
Note that some of them are named differently than in the original Git prompt by Olivier Verdier.

You can play around with different settings without reloading your shell.
The Git prompt will automatically pick up your changes to the `ZSH_THEME_GIT_PROMPT_` variables.
But remember to save them in your `.zshrc` after you tweaked them to your liking!
For example:

```zsh
source path/to/git-prompt.zsh
ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="] "
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}✚"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"
```

### Show number of stash entries
The number of stash entries will be shown if `ZSH_GIT_PROMPT_SHOW_STASH` is set.
Enabling this will execute a second Git command every time a new prompt is shown!
To enable stash entries add the following line to your `.zshrc`:

```bash
ZSH_GIT_PROMPT_SHOW_STASH=1
```

### Change the awk implementation
Some awk implementations are faster than others.
By default, the prompt checks for [nawk](https://github.com/onetrueawk/awk) and then [mawk](https://invisible-island.net/mawk/) and then falls back to the system's default awk.
You can override this behavior by setting `ZSH_GIT_PROMPT_AWK_CMD` to the awk implementation of you liking, before sourcing the `git-prompt.zsh`.

To benchmark an awk implementation you can use the following command.
```bash
# This example tests the default awk. You should change it to something else.
time ZSH_GIT_PROMPT_AWK_CMD=awk zsh -f -c '
    source path/to/git-prompt.zsh
    for i in $(seq 1000); do
        print -P $(_zsh_git_prompt_git_status)
    done'
```

## Features / Non-Features
* A pure shell implementation using [awk](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html); no Python, no Haskell required
    <!-- Well, technically awk is its own programming language and therefore not "pure shell", but heh -->
* Uses standard Git, no external Git status daemon (like [gitstatus](https://github.com/romkatv/gitstatus)) required
* Fast; Git command is invoked only once and asynchronously when a new prompt is drawn
* No caching feature, because it breaks reliable detection of untracked files

## Known issues
* If the current working directory is not a Git repository and some external application initializes a new repository in the same directory, the Git prompt will not be shown.
    Executing `git status` or any other Git command will fix the issue.
* In large repositories the prompt might slow down, because Git has to find untracked files.
    See `man git-status`, Section `--untracked-files` for possible options to speed things up.
