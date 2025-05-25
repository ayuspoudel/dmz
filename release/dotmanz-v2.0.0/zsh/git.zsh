# -------------------------------
# Git & GitHub CLI Aliases
# -------------------------------
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gco='git checkout'
alias gcb='f(){ git checkout -b "$1"; }; f'
alias gpush='./git-enhanced.sh'
alias ghpr='gh pr create --fill'
alias ghm='gh pr merge --squash --delete-branch'
