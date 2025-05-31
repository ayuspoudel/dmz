#!/bin/bash
# Runs smoke tests on the remote machine to verify dmz works.

set -euo pipefail

TEST_HOST="${DMZ_TEST_HOST:-ubuntu@your-test-server}"

echo "[INFO] Running smoke tests on $TEST_HOST"

ssh "$TEST_HOST" <<'EOF'
set -e

echo "[TEST] dmz --help"
dmz --help > /dev/null

echo "[TEST] dmz list"
dmz list > /dev/null

echo "[TEST] dmz refresh"
dmz refresh > /dev/null

echo "[SUCCESS] All smoke tests passed."
EOF
