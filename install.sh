#!/bin/bash

set -e

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Paths
INSTALL_DIR="$HOME/.dotmanz"
INSTALL_BIN="$INSTALL_DIR/dotmanz"
SYSTEM_BIN="/usr/local/bin/dotmanz"
ZSHRC="$HOME/.zshrc"

# GitHub release info
REPO="ayuspoudel/dotmanz"
TAR_URL="https://github.com/$REPO/releases/latest/download/dotmanz-v2.0.3.tar.gz"

# Step 1: Prepare target
mkdir -p "$INSTALL_DIR"

# Step 2: Download and extract binary
echo -e "${YELLOW}Downloading dotmanz binary...${RESET}"
curl -sL "$TAR_URL" | tar -xz --strip-components=1 -C "$INSTALL_DIR"

# Step 3: Make binary executable
chmod +x "$INSTALL_BIN"

# Step 4: Copy ZSH modules
echo -e "${YELLOW}Copying ZSH modules...${RESET}"
curl -sL "https://github.com/$REPO/archive/refs/heads/version-1.tar.gz" \
  | tar -xz --strip-components=2 -C "$INSTALL_DIR" "dotmanz-version-1/zsh"

# Step 5: Link to /usr/local/bin
echo -e "${YELLOW}Linking CLI to /usr/local/bin...${RESET}"
sudo ln -sf "$INSTALL_BIN" "$SYSTEM_BIN"

# Step 6: Patch .zshrc
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
