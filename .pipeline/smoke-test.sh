#!/bin/bash
# This script runs basic functional smoke tests on the remote machine where dmz was deployed.
# Written to validate that major subcommands like --help, list, refresh are working as expected.

set -e

TEST_HOST="${DMZ_TEST_HOST:-user@your-test-server}"

echo "[INFO] Running remote smoke tests on $TEST_HOST..."

ssh "$TEST_HOST" <<'EOF'
set -e
echo "[INFO] Checking dmz --help..."
dmz --help

echo "[INFO] Checking dmz list..."
dmz list

echo "[INFO] Checking dmz refresh..."
dmz refresh

echo "[SUCCESS] All dmz smoke tests passed"
EOF
