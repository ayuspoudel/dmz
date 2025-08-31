#!/bin/bash
set -euo pipefail

# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

INSTALL_DIR="$HOME/.dmz"
INSTALL_BIN="$INSTALL_DIR/dmz"
SYSTEM_BIN="/usr/local/bin/dmz"
ZSHRC="$HOME/.zshrc"

REPO="ayuspoudel/dmz"

# Allow user to override version: VERSION=v2.2.0 ./install.sh
VERSION="${VERSION:-}"

# Step 1: Figure out which version to install
if [[ -z "$VERSION" ]]; then
  echo -e "${YELLOW}Fetching latest release tag...${RESET}"
  VERSION=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep -Po '"tag_name": "\K.*?(?=")')
fi

if [[ -z "$VERSION" ]]; then
  echo -e "${RED}Could not determine latest release${RESET}"
  exit 1
fi

TAR_URL="https://github.com/$REPO/releases/download/$VERSION/dmz-$VERSION.tar.gz"

echo -e "${YELLOW}Installing dmz $VERSION...${RESET}"

# Step 2: Prepare dirs
mkdir -p "$INSTALL_DIR"

# Step 3: Download + extract directly into ~/.dmz
TMPDIR=$(mktemp -d)
curl -fsSL "$TAR_URL" -o "$TMPDIR/dmz.tar.gz"
tar -xzf "$TMPDIR/dmz.tar.gz" -C "$TMPDIR"
rsync -a "$TMPDIR/dmz-$VERSION"/ "$INSTALL_DIR"/
rm -rf "$TMPDIR"

# Step 4: Make binary executable
chmod +x "$INSTALL_BIN"

# Step 5: Link to /usr/local/bin
echo -e "${YELLOW}Linking CLI to /usr/local/bin...${RESET}"
sudo ln -sf "$INSTALL_BIN" "$SYSTEM_BIN"

# Step 6: Patch .zshrc with module loader
HEADER_LINE="# dmz module loader"
SOURCE_LINE='for f in $HOME/.dmz/zsh/*.zsh; do source "$f"; done'
if ! grep -Fq "$SOURCE_LINE" "$ZSHRC"; then
  {
    echo -e "\n$HEADER_LINE"
    echo "$SOURCE_LINE"
  } >> "$ZSHRC"
  echo -e "${GREEN}Updated .zshrc with module loader${RESET}"
else
  echo -e "${YELLOW}Notice:${RESET} .zshrc already configured."
fi

# Step 7: Install ZSH completions
echo -e "${YELLOW}Installing completions...${RESET}"
mkdir -p "$HOME/.zsh/completions"
if [[ -f "$INSTALL_DIR/completions/_dmz" ]]; then
  cp "$INSTALL_DIR/completions/_dmz" "$HOME/.zsh/completions/"
  if ! grep -Fq 'fpath+=~/.zsh/completions' "$ZSHRC"; then
    {
      echo -e "\nfpath+=~/.zsh/completions"
      echo 'autoload -Uz compinit && compinit'
    } >> "$ZSHRC"
    echo -e "${GREEN}Updated .zshrc with completions loader${RESET}"
  fi
fi

# Done
echo -e "\n${GREEN} dmz installed successfully!${RESET}"
echo -e "${YELLOW}Run:${RESET} source ~/.zshrc"
echo -e "${YELLOW}Try:${RESET} dmz list"
