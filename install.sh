#!/bin/bash

set -e

echo "📦 Installing dotmanz..."

INSTALL_DIR="$HOME/.dotmanz"
BIN_PATH="/usr/local/bin"

mkdir -p "$INSTALL_DIR"
cp -r ./zsh "$INSTALL_DIR/zsh"
cp ./dot "$INSTALL_DIR/"

# Symlink CLI
chmod +x "$INSTALL_DIR/dot"
ln -sf "$INSTALL_DIR/dot" "$BIN_PATH/dot"

# Add sourcing to .zshrc (if not present)
ZSHRC="$HOME/.zshrc"
SOURCE_LINE='for f in $HOME/.dotmanz/zsh/*.zsh; do source $f; done'
if ! grep -Fxq "$SOURCE_LINE" "$ZSHRC"; then
  echo "$SOURCE_LINE" >> "$ZSHRC"
  echo "✅ .zshrc updated"
fi

echo "✅ Installed! Run: source ~/.zshrc"
