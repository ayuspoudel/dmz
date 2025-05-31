#!/bin/bash
# This script verifies SSH access to the test server using a preset environment variable or fallback.
# Written to check if the remote test machine is reachable before pushing binaries or executing remote tests.

set -e

TEST_HOST="${DMZ_TEST_HOST:-user@your-test-server}"
echo "[INFO] Testing SSH connection to: $TEST_HOST"

ssh -o BatchMode=yes "$TEST_HOST" 'echo "[OK] Connected to test host successfully"'
