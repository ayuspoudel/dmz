#!/bin/bash

set -e

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Paths
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="$HOME/.dotmanz"
INSTALL_BIN="$INSTALL_DIR/dotmanz"
SYSTEM_BIN="/usr/local/bin/dotmanz"
ZSHRC="$HOME/.zshrc"

# Step 1: Prepare target
mkdir -p "$INSTALL_DIR"

# Step 2: Copy binary
if [[ ! -f "$REPO_DIR/dotmanz" ]]; then
  echo -e "${RED}Error:${RESET} dotmanz binary not found in $REPO_DIR"
  exit 1
fi

echo -e "${YELLOW}Installing dotmanz binary...${RESET}"
cp "$REPO_DIR/dotmanz" "$INSTALL_BIN"
chmod +x "$INSTALL_BIN"

# Step 3: Copy ZSH modules
echo -e "${YELLOW}Copying ZSH modules...${RESET}"
cp -r "$REPO_DIR/zsh" "$INSTALL_DIR/zsh"

# Step 4: Link to /usr/local/bin
echo -e "${YELLOW}Linking CLI to /usr/local/bin...${RESET}"
sudo ln -sf "$INSTALL_BIN" "$SYSTEM_BIN"

# Step 5: Patch .zshrc to source from ~/.dotmanz/zsh
HEADER_LINE="# dotmanz module loader"
SOURCE_LINE='for f in $HOME/.dotmanz/zsh/*.zsh; do source "$f"; done'

if grep -Fq "$SOURCE_LINE" "$ZSHRC"; then
  echo -e "${YELLOW}Notice:${RESET} .zshrc already configured."
else
  echo -e "\n$HEADER_LINE" >> "$ZSHRC"
  echo "$SOURCE_LINE" >> "$ZSHRC"
  echo -e "${GREEN}Updated:${RESET} .zshrc with module loader"
fi

# Done
echo -e "\n${GREEN}dotmanz installed successfully!${RESET}"
echo -e "${YELLOW}Run:${RESET} source ~/.zshrc"
echo -e "${YELLOW}Try:${RESET} dotmanz list"
