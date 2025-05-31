#!/bin/bash
# This script builds the app in release mode and verifies the binary exists.
# Written to ensure reproducible builds and confirm that the compiled binary is valid before testing or deploying.

set -e

echo "[INFO] Starting release build..."
cargo build --release

BIN_PATH="target/release/dmz"
if [[ -f "$BIN_PATH" ]]; then
  echo "[SUCCESS] Build successful: $BIN_PATH"
else
  echo "[ERROR] Build failed: $BIN_PATH not found"
  exit 1
fi
