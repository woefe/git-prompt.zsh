# Informative Git prompt for Zsh

<img src="screenshot.png" width="400" />

A fast, pure-shell, single-file Git prompt for Zsh.
It is heavily inspired by Olivier Verdier's [zsh-git-prompt](https://github.com/olivierverdier/zsh-git-prompt) and very similar to the "Informative VCS" prompt of fish shell.

This prompt requires Git with `--porcelain=v2` support, which is available since version 2.11.0.
You can check if your installation is compatible by executing `git status --branch --porcelain=v2` inside a Git repository.

## Installation
Clone this repo or [download](https://raw.githubusercontent.com/woefe/zsh-git-prompt/master/git-prompt.zsh) the `git-prompt.zsh` file.
Then add following lines to your `.zshrc`.

```
prompt off  # Optional in some cases
source path/to/git-prompt.zsh
PROMPT='%B%40<..<%~ %b$(gitprompt)%(?.%F{blue}❯%f%F{cyan}❯%f%F{green}❯%f.%F{red}❯❯❯%f) '
```


## Prompt Structure
The structure of the prompt is the following:

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


## Customization

### Appearance
The appearance of the prompt can be adjusted by changing the variables that start with `ZSH_THEME_GIT_PROMPT_`.
Take a look at the beginning of the [git-prompt.zsh](./git-prompt.zsh) file to see which variables are available and what their defaults are.
Note that some of them are named differently than in the original Git prompt by Olivier Verdier.
You can play around with different settings without reloading your shell.
The Git prompt will automatically pick up your changes to the `ZSH_THEME_GIT_PROMPT_` variables.
But remember to save them in your `.zshrc` after you tweaked them to your liking!

### Show number of stash entries
The number of stash entries will be shown if `ZSH_GIT_PROMPT_SHOW_STASH` is set.
Enabling this will execute a second Git command every time a new prompt is shown!
To enable stash entries add the following line to your `.zshrc`:

```bash
ZSH_GIT_PROMPT_SHOW_STASH=1
```

## Features / Non-Features
* A pure shell implementation using [awk](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/awk.html); no Python, no Haskell required
    <!-- Well, technically awk is its own programming language and therefore not "pure shell", but heh -->
* Uses standard Git, no external Git status daemon (like [gitstatus](https://github.com/romkatv/gitstatus)) required
* Fast; Git command is invoked only once when a new prompt is shown in a Git repo (and at some other places to detect if you are currently within a Git repository)
* No caching feature, because it breaks reliable detection of untracked files

## Known issues
* If the current working directory is not a Git repository and some external application initializes a new repository in the same directory, the Git prompt will not be shown.
    Executing `git status` or any other Git command will fix the issue.
* In large repositories the prompt might slow down, because Git has to find untracked files.
    See `man git-status`, Section `--untracked-files` for possible options to speed things up.

## Benchmarks
These benchmarks compare the performance of this prompt against the prompts maintained by **@starcraftman** and **@Streetwalrus**.
The prompt by **@starcraftman** is a fork of the original by **@olivierverdier**.
We compare against the Python, not the Haskell version of the original prompt with caching disabled.
The prompt by **@Streetwalrus** is an implementation in Rust.
The benchmarks measure the execution time of 100 invocations of the `gitprompt` and `git_super_status` functions and `gitprompt-rs` command.
Those functions and commands are responsible for rendering the Git information in the prompt.

| configuration                                                                                  | time for 100 prompts |
|------------------------------------------------------------------------------------------------|----------------------|
| [woefe/git-prompt.zsh](https://github.com/woefe/git-prompt.zsh) outside git repo               | 0.064s               |
| [woefe/git-prompt.zsh](https://github.com/woefe/git-prompt.zsh) inside git repo                | 0.493s               |
| [woefe/git-prompt.zsh](https://github.com/woefe/git-prompt.zsh) inside git repo with stash     | 0.543s               |
| [starcraftman/zsh-git-prompt](https://github.com/starcraftman/zsh-git-prompt) outside git repo | 3.044s               |
| [starcraftman/zsh-git-prompt](https://github.com/starcraftman/zsh-git-prompt) inside git repo  | 3.051s               |
| [Streetwalrus/gitprompt-rs](https://github.com/Streetwalrus/gitprompt-rs) outside git repo     | 0.283s               |
| [Streetwalrus/gitprompt-rs](https://github.com/Streetwalrus/gitprompt-rs) inside git repo      | 0.367s               |

All benchmarks were executed on a Dell XPS 13 9370 laptop connected to wall power, with an Intel Core i7-8550U, 16GB RAM, 512GB M.2 NVMe SSD.
The terminal emulator was [Alacritty](https://github.com/jwilm/alacritty).

The [gitprompt-rs](https://github.com/Streetwalrus/gitprompt-rs) is the fastest inside git repos, but by default slower outside of git repos and also harder to customize.
You will have to patch the Rust source and recompile it, if you want to customize it.

### Commands used for benchmarking

```bash
# woefe/git-prompt.zsh
time zsh -c 'source ~/workspace/git-prompt.zsh/git-prompt.zsh; for i in $(seq 100); do print -P $(gitprompt); done'

# woefe/git-prompt.zsh with stash
time zsh -c 'source ~/workspace/git-prompt.zsh/git-prompt.zsh; ZSH_GIT_PROMPT_SHOW_STASH=1; for i in $(seq 100); do print -P $(gitprompt); done'

# starcraftman/zsh-git-prompt
time zsh -c 'source /tmp/starcraftman/zsh-git-prompt/zshrc.sh; for i in $(seq 100); do print -P $(git_super_status); done'

# Streetwalrus/gitprompt-rs (gitprompt-rs installed from Arch repo)
time zsh -c 'for i in $(seq 100); do print -P $(gitprompt-rs); done'
```
