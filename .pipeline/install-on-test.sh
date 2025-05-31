#!/bin/bash
# Copies and installs the built binary to the remote server.

set -euo pipefail

BIN_PATH="target/release/dmz"
TEST_HOST="${DMZ_TEST_HOST:-ubuntu@your-test-server}"
REMOTE_PATH="/tmp/dmz"

echo "[INFO] Uploading $BIN_PATH to $TEST_HOST:$REMOTE_PATH"
scp -o StrictHostKeyChecking=no "$BIN_PATH" "$TEST_HOST:$REMOTE_PATH"

echo "[INFO] Installing binary on remote server..."
ssh "$TEST_HOST" "chmod +x $REMOTE_PATH && sudo mv $REMOTE_PATH /usr/local/bin/dmz && echo '[OK] dmz installed at /usr/local/bin/dmz'"
