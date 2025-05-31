#!/bin/bash
set -e

# Define paths
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_HOME="$ROOT_DIR/test-env"
dmz_BIN="$ROOT_DIR/target/debug/dmz"
FAKE_ZSHRC="$TEST_HOME/.zshrc"
FAKE_dmz="$TEST_HOME/.dmz"

# Rebuild the CLI
echo "[🔧] Building dmz..."
cargo build

# Prepare test directories
mkdir -p "$FAKE_dmz/zsh"
mkdir -p "$FAKE_dmz/completions"

# Create a clean .zshrc if it doesn't exist
if [ ! -f "$FAKE_ZSHRC" ]; then
  echo "# dmz sandbox .zshrc" > "$FAKE_ZSHRC"
  echo "for f in \$HOME/.dmz/zsh/*.zsh; do source \"\$f\"; done" >> "$FAKE_ZSHRC"
  echo "fpath+=\$HOME/.dmz/completions" >> "$FAKE_ZSHRC"
  echo "autoload -Uz compinit && compinit" >> "$FAKE_ZSHRC"
fi

# Run dmz with test HOME
echo "[🚀] Running dmz in sandbox:"
echo "HOME=$TEST_HOME"
HOME="$TEST_HOME" "$dmz_BIN" "$@"
