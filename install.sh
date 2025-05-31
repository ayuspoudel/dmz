#!/bin/bash

set -e

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Paths
INSTALL_DIR="$HOME/.dmz"
INSTALL_BIN="$INSTALL_DIR/dmz"
SYSTEM_BIN="/usr/local/bin/dmz"
ZSHRC="$HOME/.zshrc"

# GitHub release info
REPO="ayuspoudel/dmz"
VERSION="${VERSION:-v2.0.5}"
TAR_URL="https://github.com/$REPO/releases/download/$VERSION/dmz-$VERSION.tar.gz"

# Step 1: Prepare target
mkdir -p "$INSTALL_DIR"

# Step 2: Download and extract binary
echo -e "${YELLOW}Downloading dmz binary...${RESET}"
if ! curl -sL "$TAR_URL" | tar -xz --strip-components=1 -C "$INSTALL_DIR"; then
  echo -e "${RED}❌ Failed to extract tarball from $TAR_URL${RESET}"
  exit 1
fi

# Step 3: Make binary executable
chmod +x "$INSTALL_BIN"

# Step 4: Copy ZSH modules
echo -e "${YELLOW}Copying ZSH modules...${RESET}"
curl -sL "https://github.com/$REPO/archive/refs/heads/version-1.tar.gz" \
  | tar -xz --strip-components=2 -C "$INSTALL_DIR" "dmz-version-1/zsh"

# Step 5: Link to /usr/local/bin
echo -e "${YELLOW}Linking CLI to /usr/local/bin...${RESET}"
sudo ln -sf "$INSTALL_BIN" "$SYSTEM_BIN"

# Step 6: Patch .zshrc
HEADER_LINE="# dmz module loader"
SOURCE_LINE='for f in $HOME/.dmz/zsh/*.zsh; do source "$f"; done'

if grep -Fq "$SOURCE_LINE" "$ZSHRC"; then
  echo -e "${YELLOW}Notice:${RESET} .zshrc already configured."
else
  echo -e "\n$HEADER_LINE" >> "$ZSHRC"
  echo "$SOURCE_LINE" >> "$ZSHRC"
  echo -e "${GREEN}Updated:${RESET} .zshrc with module loader"
fi

# Step 7: Install ZSH shell completions
echo -e "${YELLOW}Installing shell completions...${RESET}"
mkdir -p "$HOME/.zsh/completions"
cp "$INSTALL_DIR/completions/_dmz" "$HOME/.zsh/completions/"

# Patch .zshrc to load completions if not already set
if ! grep -Fq 'fpath+=~/.zsh/completions' "$ZSHRC"; then
  echo -e "\nfpath+=~/.zsh/completions" >> "$ZSHRC"
  echo 'autoload -Uz compinit && compinit' >> "$ZSHRC"
  echo -e "${GREEN}Updated:${RESET} .zshrc with completions loader"
fi

# Done
echo -e "\n${GREEN}dmz installed successfully!${RESET}"
echo -e "${YELLOW}Run:${RESET} source ~/.zshrc"
echo -e "${YELLOW}Try:${RESET} dmz list"
