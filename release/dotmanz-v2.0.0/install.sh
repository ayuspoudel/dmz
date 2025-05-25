#!/bin/bash

set -e

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Define paths
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$HOME/.dotmanz"
INSTALL_BIN="$INSTALL_DIR/dot"
SYSTEM_BIN="/usr/local/bin/dot"
ZSHRC="$HOME/.zshrc"

# Build binary
echo -e "${YELLOW}Building release binary...${RESET}"
cargo build --release --manifest-path "$REPO_DIR/Cargo.toml"

# Create install directory
mkdir -p "$INSTALL_DIR"
cp "$REPO_DIR/target/release/dot" "$INSTALL_BIN"
chmod +x "$INSTALL_BIN"

# Copy zsh modules
echo -e "${YELLOW}Copying ZSH modules...${RESET}"
cp -r "$REPO_DIR/zsh" "$INSTALL_DIR/zsh"

# Symlink to /usr/local/bin
echo -e "${YELLOW}Linking CLI to /usr/local/bin...${RESET}"
sudo ln -sf "$INSTALL_BIN" "$SYSTEM_BIN"

# Patch .zshrc
SOURCE_LINE='for f in $HOME/.dotmanz/zsh/*.zsh; do source "$f"; done'
HEADER_LINE="# dotmanz module loader"

if grep -Fq "$SOURCE_LINE" "$ZSHRC"; then
  echo -e "${YELLOW}Notice:${RESET} .zshrc already configured."
else
  echo -e "\n$HEADER_LINE" >> "$ZSHRC"
  echo "$SOURCE_LINE" >> "$ZSHRC"
  echo -e "${GREEN}Updated:${RESET} .zshrc with module loader"
fi

# Done
echo -e "\n${GREEN}✅ dotmanz installed successfully!${RESET}"
echo -e "${YELLOW}Run:${RESET} source ~/.zshrc"
echo -e "${YELLOW}Try:${RESET} dot list"
