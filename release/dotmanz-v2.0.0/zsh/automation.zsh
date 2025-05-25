# -------------------------------
# Automation Script Runner
# -------------------------------

AUTOMATION_DIR="$HOME/Code/bin"

# Ensure the automation dir is in PATH
export PATH="$AUTOMATION_DIR:$PATH"

# List and run automation scripts
run() {
  if [[ -z "$1" ]]; then
    echo -e "\n Available automation scripts in $AUTOMATION_DIR:\n"
    for f in "$AUTOMATION_DIR"/*; do
      [[ -x "$f" && -f "$f" ]] && echo "  $(basename "$f")"
    done
    echo -e "\n Usage: run <script-name>\n"
  else
    local script="$AUTOMATION_DIR/$1"
    if [[ -x "$script" ]]; then
      "$script" "${@:2}"
    else
      echo "Script not found or not executable: $script"
    fi
  fi
}
