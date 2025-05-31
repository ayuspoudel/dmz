#!/bin/bash
# This script updates the version in Cargo.toml, commits the change, and tags the repo.
# Written to automate the version bump process so I don’t have to manually edit Cargo.toml or run git commands for releases.

set -e

VERSION="$1"
if [[ -z "$VERSION" ]]; then
  echo "[ERROR] Usage: $0 <version>"
  exit 1
fi

echo "[INFO] Bumping version to $VERSION..."

if grep -q '^version = ' Cargo.toml; then
  sed -i.bak "s/^version = \".*\"/version = \"$VERSION\"/" Cargo.toml
  rm Cargo.toml.bak
  echo "[OK] Updated version in Cargo.toml"
else
  echo "[ERROR] Version line not found in Cargo.toml"
  exit 1
fi

echo "[INFO] Committing and tagging..."
git add Cargo.toml
git commit -m "chore: bump version to $VERSION"
git tag "v$VERSION"
echo "[SUCCESS] Commit and tag created: v$VERSION"
