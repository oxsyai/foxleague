#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/common.sh"

SC_ADDRESS="${SC_ADDRESS:-$(load_address)}"
require_env SC_ADDRESS
require_env MX_WALLET
require_env MX_NETWORK

# Required params (envs):
# TOKEN_ID:      e.g., FOXSY-xxxxxx (must match setToken)
# T_ID:          BigUint (e.g., 1)
# START:         UTC seconds (default: now + 2h)
# END:           UTC seconds (default: now + 3d; must satisfy minRegistrationTime)
# REG_FEE:       BigUint (fee per registration)
# PRIZE:         BigUint (sent as ESDT payment)
require_env TOKEN_ID
require_env T_ID
NOW="$(date -u +%s)"
START="${START:-$((NOW + 2*3600))}"
END="${END:-$((NOW + 3*24*3600))}"
require_env REG_FEE
require_env PRIZE

log "Creating tournament id=$T_ID start=$START end=$END fee=$REG_FEE prize=$PRIZE token=$TOKEN_ID"
mxpy contract call "$SC_ADDRESS" --function createTournament \
  --pem "$MX_WALLET" --network "$MX_NETWORK" \
  --gas-limit=90000000 --recall-nonce --send \
  --arguments "$T_ID" "$START" "$END" "$REG_FEE" \
  --token "$TOKEN_ID" --amount "$PRIZE"

log "✅ createTournament submitted"
