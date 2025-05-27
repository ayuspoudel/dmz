#!/bin/bash
set -e

# Define paths
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_HOME="$ROOT_DIR/test-env"
DOTMANZ_BIN="$ROOT_DIR/target/debug/dotmanz"
FAKE_ZSHRC="$TEST_HOME/.zshrc"
FAKE_DOTMANZ="$TEST_HOME/.dotmanz"

# Rebuild the CLI
echo "[🔧] Building dotmanz..."
cargo build

# Prepare test directories
mkdir -p "$FAKE_DOTMANZ/zsh"
mkdir -p "$FAKE_DOTMANZ/completions"

# Create a clean .zshrc if it doesn't exist
if [ ! -f "$FAKE_ZSHRC" ]; then
  echo "# dotmanz sandbox .zshrc" > "$FAKE_ZSHRC"
  echo "for f in \$HOME/.dotmanz/zsh/*.zsh; do source \"\$f\"; done" >> "$FAKE_ZSHRC"
  echo "fpath+=\$HOME/.dotmanz/completions" >> "$FAKE_ZSHRC"
  echo "autoload -Uz compinit && compinit" >> "$FAKE_ZSHRC"
fi

# Run dotmanz with test HOME
echo "[🚀] Running dotmanz in sandbox:"
echo "HOME=$TEST_HOME"
HOME="$TEST_HOME" "$DOTMANZ_BIN" "$@"
