#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/common.sh"

SC_ADDRESS="${SC_ADDRESS:-$(load_address)}"
require_env SC_ADDRESS
require_env MX_WALLET
require_env MX_NETWORK

# Required params:
# TOKEN_ID:      ESDT to pay fee
# TOURNAMENT_ID: id of tournament
# TEAM_SETUP_ID: your team setup id
# FEE_AMOUNT:    amount to send (>= registration_fee); excess refunded
require_env TOKEN_ID
require_env TOURNAMENT_ID
require_env TEAM_SETUP_ID
require_env FEE_AMOUNT

log "Registering tournament=$TOURNAMENT_ID team_setup_id=$TEAM_SETUP_ID fee=$FEE_AMOUNT token=$TOKEN_ID"
mxpy contract call "$SC_ADDRESS" --function register \
  --pem "$MX_WALLET" --network "$MX_NETWORK" \
  --gas-limit=60000000 --recall-nonce --send \
  --arguments "$TOURNAMENT_ID" "$TEAM_SETUP_ID" \
  --token "$TOKEN_ID" --amount "$FEE_AMOUNT"

log "✅ register submitted"
