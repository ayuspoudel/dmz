#!/bin/bash
# This script copies the built binary to the remote test machine and installs it to /usr/local/bin.
# Written to automate remote deployment of the latest compiled version of dmz for hands-on testing.

set -e

BIN_PATH="target/release/dmz"
TEST_HOST="${DMZ_TEST_HOST:-user@your-test-server}"
REMOTE_PATH="/tmp/dmz"

echo "[INFO] Copying binary to test host: $TEST_HOST"
scp "$BIN_PATH" "$TEST_HOST:$REMOTE_PATH"
echo "[OK] Binary copied to: $REMOTE_PATH"

echo "[INFO] Installing dmz on test host..."
ssh "$TEST_HOST" "chmod +x $REMOTE_PATH && sudo mv $REMOTE_PATH /usr/local/bin/dmz"
echo "[SUCCESS] dmz installed at /usr/local/bin/dmz"
