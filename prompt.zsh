# -------------------------------
# ZSH Prompt Setup
# -------------------------------
autoload -Uz colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
setopt prompt_subst

zstyle ':vcs_info:git:*' formats '%F{yellow}%b%f'
zstyle ':vcs_info:git:*' actionformats '%F{yellow}%b|%a%f'

PROMPT='%F{green}%n@%m%f %F{blue}%~%f %F{cyan}${vcs_info_msg_0_}%f
%F{magenta}%*%f → '
