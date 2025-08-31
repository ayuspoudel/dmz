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
VERSION="${VERSION:-}"

# Detect OS + ARCH
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
esac

# Step 1: Figure out which version to install
if [[ -z "$VERSION" ]]; then
  echo -e "${YELLOW}Fetching latest release tag...${RESET}"
  VERSION=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | sed -n 's/.*"tag_name": "\(.*\)".*/\1/p')
fi

if [[ -z "$VERSION" ]]; then
  echo -e "${RED}Could not determine latest release${RESET}"
  exit 1
fi

# Step 2: Construct candidate URLs
BASE_URL="https://github.com/$REPO/releases/download/$VERSION"
TAR_SIMPLE="dmz-$VERSION.tar.gz"
TAR_ARCH="dmz-$VERSION-$OS-$ARCH.tar.gz"

if curl --head --silent --fail "$BASE_URL/$TAR_SIMPLE" >/dev/null; then
  TAR_URL="$BASE_URL/$TAR_SIMPLE"
elif curl --head --silent --fail "$BASE_URL/$TAR_ARCH" >/dev/null; then
  TAR_URL="$BASE_URL/$TAR_ARCH"
else
  echo -e "${RED}No release asset found for $VERSION (${OS}/${ARCH})${RESET}"
  exit 1
fi

echo -e "${YELLOW}Installing dmz $VERSION from $TAR_URL...${RESET}"

# Step 3: Prepare dirs
mkdir -p "$INSTALL_DIR"

# Step 4: Download + extract
TMPDIR=$(mktemp -d)
curl -fsSL "$TAR_URL" -o "$TMPDIR/dmz.tar.gz"
tar -xzf "$TMPDIR/dmz.tar.gz" -C "$TMPDIR"
rsync -a "$TMPDIR"/dmz-*/* "$INSTALL_DIR"/ || true
rm -rf "$TMPDIR"

# Step 5: Make binary executable
chmod +x "$INSTALL_BIN"

# Step 6: Link to /usr/local/bin
echo -e "${YELLOW}Linking CLI to /usr/local/bin...${RESET}"
sudo ln -sf "$INSTALL_BIN" "$SYSTEM_BIN"

# Step 7: Patch .zshrc with module loader
HEADER_LINE="# dmz module loader"
SOURCE_LINE='for f in $HOME/.dmz/zsh/*.zsh; do source "$f"; done'
if ! grep -Fq "$SOURCE_LINE" "$ZSHRC"; then
  {
    echo -e "\n$HEADER_LINE"
    echo "$SOURCE_LINE"
  } >> "$ZSHRC"
  echo -e "${GREEN}Updated .zshrc with module loader${RESET}"
fi

# Step 8: Install ZSH completions
echo -e "${YELLOW}Installing completions...${RESET}"
mkdir -p "$HOME/.zsh/completions"
if [[ -f "$INSTALL_DIR/completions/_dmz" ]]; then
  cp "$INSTALL_DIR/completions/_dmz" "$HOME/.zsh/completions/"
  if ! grep -Fq 'fpath+=~/.zsh/completions' "$ZSHRC"; then
    {
      echo -e "\nfpath+=~/.zsh/completions"
      echo 'autoload -Uz compinit && compinit'
    } >> "$ZSHRC"
  fi
fi

echo -e "\n${GREEN}dmz installed successfully!${RESET}"
echo -e "${YELLOW}Run:${RESET} source ~/.zshrc"
echo -e "${YELLOW}Try:${RESET} dmz list"
