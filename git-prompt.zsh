# zsh-git-prompt a lightweight git prompt for zsh.
# Copyright © 2018 Wolfgang Popp
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


setopt PROMPT_SUBST

ZSH_THEME_GIT_PROMPT_BRANCH=${ZSH_THEME_GIT_PROMPT_BRANCH:-%F{magenta}%B}
ZSH_THEME_GIT_PROMPT_STAGED=${ZSH_THEME_GIT_PROMPT_STAGED:-%F{red}}
ZSH_THEME_GIT_PROMPT_CHANGED=${ZSH_THEME_GIT_PROMPT_CHANGED:-%F{red}}
ZSH_THEME_GIT_PROMPT_CONFLICTS=${ZSH_THEME_GIT_PROMPT_CONFLICTS:-%F{blue}}

function gitprompt() {
    git status --branch --porcelain=v2 2>&1 | awk '
        BEGIN {
            ZSH_THEME_GIT_PROMPT_STAGED = "'"$ZSH_THEME_GIT_PROMPT_STAGED"'";
            ZSH_THEME_GIT_PROMPT_BRANCH = "'"$ZSH_THEME_GIT_PROMPT_BRANCH"'";
            ZSH_THEME_GIT_PROMPT_CHANGED = "'"$ZSH_THEME_GIT_PROMPT_CHANGED"'";
            ZSH_THEME_GIT_PROMPT_CONFLICTS = "'"$ZSH_THEME_GIT_PROMPT_CONFLICTS"'";
            GREEN = "%F{green}";
            NB = "%b";
            NC = "%f";

            fatal = 0;
            oid = "";
            head = "";
            ahead = 0;
            behind = 0;
            untracked = 0;
            unmerged = 0;
            staged = 0;
            unstaged = 0;
        }

        $1 == "fatal:" {
            fatal = 1;
        }

        $2 == "branch.oid" {
            oid = $3;
        }

        $2 == "branch.head" {
            head = $3;
        }

        $2 == "branch.ab" {
            ahead = $3;
            behind = $4;
        }

        $1 == "?" {
            ++untracked;
        }

        $1 == "u" {
            ++unmerged;
        }

        $1 == "1" || $1 == "2" {
            split($2, arr, "");
            if (arr[1] != ".") {
                ++staged;
            }
            if (arr[2] != ".") {
                ++unstaged;
            }
        }

        END {
            if (fatal == 1) {
                exit(1);
            }

            printf "[";

            printf "%s", ZSH_THEME_GIT_PROMPT_BRANCH
            if (head == "(detached)") {
                printf ":%s", substr(oid, 0, 7);
            } else {
                printf "%s", head;
            }
            printf "%s", NB
            printf "%s", NC

            if (behind < 0) {
                printf "↓%d", behind * -1;
            }

            if (ahead > 0) {
                printf "↑%d", ahead;
            }

            printf "|";

            if (unmerged > 0) {
                printf "%s", ZSH_THEME_GIT_PROMPT_CONFLICTS
                printf "✖%d", unmerged;
                printf "%s", NC
            }

            if (staged > 0) {
                printf "%s", ZSH_THEME_GIT_PROMPT_STAGED
                printf "●%d", staged;
                printf "%s", NC
            }

            if (unstaged > 0) {
                printf "%s", ZSH_THEME_GIT_PROMPT_CHANGED
                printf "✚%d", unstaged;
                printf "%s", NC
            }

            if (untracked > 0) {
                printf "%s", ZSH_THEME_GIT_PROMPT_CHANGED
                printf "…%d", untracked;
                printf "%s", NC
            }

            if (unmerged == 0 && staged == 0 && unstaged == 0 && untracked == 0) {
                printf "%s", GREEN
                printf "✔"
                printf "%s", NC
            }

            printf "] ";
        }
    '
}
