# -------------------------------
# Safe Command Behavior + History
# -------------------------------
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

HIST_STAMPS="mm/dd/yyyy"
export LESSOPEN="| /usr/bin/lesspipe %s"
export LESS=' -R '
