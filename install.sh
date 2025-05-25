#!/bin/bash

set -e

# Color codes
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
RED="\033[0;31m"
RESET="\033[0m"

echo -e "${BLUE}Installing dotmanz...${RESET}"

INSTALL_DIR="$HOME/.dotmanz"
BIN_PATH="/usr/local/bin"

# Create target directories
mkdir -p "$INSTALL_DIR"
cp -r ./zsh "$INSTALL_DIR/zsh"
cp ./dot "$INSTALL_DIR/"

# Set executable permission and link to /usr/local/bin
chmod +x "$INSTALL_DIR/dot"
echo -e "${BLUE}Linking CLI to $BIN_PATH...${RESET}"
sudo ln -sf "$INSTALL_DIR/dot" "$BIN_PATH/dot"

# Update .zshrc to source all zsh modules if not already present
ZSHRC="$HOME/.zshrc"
SOURCE_LINE='for f in $HOME/.dotmanz/zsh/*.zsh; do source $f; done'
if grep -Fxq "$SOURCE_LINE" "$ZSHRC"; then
  echo -e "${YELLOW}Notice:${RESET} .zshrc already configured"
else
  echo "$SOURCE_LINE" >> "$ZSHRC"
  echo -e "${GREEN}Updated:${RESET} .zshrc with dotmanz source line"
fi

echo -e "${GREEN}Installation complete.${RESET}"
echo -e "${BLUE}Run:${RESET} source ~/.zshrc"
