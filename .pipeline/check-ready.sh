#!/bin/bash
# Verifies SSH connectivity to the test server.

set -euo pipefail

TEST_HOST="${DMZ_TEST_HOST:-ubuntu@your-test-server}"
echo "[INFO] Checking SSH access to: $TEST_HOST"

ssh -o BatchMode=yes -o ConnectTimeout=10 "$TEST_HOST" 'echo "[OK] SSH connection successful."' || {
  echo "[ERROR] SSH connection failed to $TEST_HOST"
  exit 1
}
