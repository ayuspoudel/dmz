# -------------------------------
# Helper: Show Aliases by Group
# -------------------------------

alias_group() {
  local group="$1"
  local keyword="$2"
  local file="$HOME/Code/dotfiles/zsh/${group}.zsh"

  if [[ ! -f "$file" ]]; then
    echo " No alias group found for: $group"
    return 1
  fi

  echo -e "\n Aliases from: ${group}.zsh${keyword:+ (filtered by \"$keyword\")}:\n"

  grep -E '^\s*alias ' "$file" | while read -r line; do
    local name=$(echo "$line" | cut -d'=' -f1 | awk '{print $2}')
    local value=$(echo "$line" | cut -d'=' -f2- | sed -E "s/^['\"]?|['\"]$//g")

    if [[ -z "$keyword" || "$name" == *"$keyword"* || "$value" == *"$keyword"* ]]; then
      printf "  %-15s → %s\n" "$name" "$value"
    fi
  done

  echo
}


# Define shortcut aliases for most-used groups
# Shortcuts for viewing alias groups
# Group viewers (safe names that won't conflict with aliases)
alias a.aws='alias_group aws'
alias a.terraform='alias_group terraform'
alias a.git='alias_group git'
alias a.docker='alias_group docker'
alias a.aliases='alias_group aliases'
alias a.prompt='alias_group prompt'
alias a.plugins='alias_group plugins'
alias a.safety='alias_group safety'
alias a.dynatrace='alias_group dynatrace'


# -------------------------------
# help → shows available alias groups
# -------------------------------

help() {
  echo -e "\n Available alias groups:"
  for f in "$HOME/Code/dotfiles/zsh/"*.zsh; do
    name=$(basename "$f" .zsh)
    [[ "$name" == "private" ]] && continue
    echo "  • $name"
  done
  echo -e "\n Usage: type the group name to view its aliases (e.g. aws, terraform, git)\n"
}

# safety guard (optional)
for reserved in git aws terraform docker; do
  if alias "$reserved" &>/dev/null; then
    echo "⚠️  Warning: '$reserved' is aliased and may break real commands. Consider using 'a.$reserved'"
  fi
done
