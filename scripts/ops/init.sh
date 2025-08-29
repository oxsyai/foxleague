#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/common.sh"

SC_ADDRESS="${SC_ADDRESS:-$(load_address)}"
require_env SC_ADDRESS
require_env MX_WALLET
require_env MX_NETWORK

# Optional/required config from env (set in .env or export before running)
# Required: FEES_RECEIVER, PRIZES_RECEIVER, TOKEN_ID (e.g. FOXSY-xxxxxx)
# Required: MIN_REGISTRATION_FEE (BigUint), MIN_PRIZE (BigUint), MIN_REG_TIME (u64 seconds)
require_env FEES_RECEIVER
require_env PRIZES_RECEIVER
require_env TOKEN_ID
require_env MIN_REGISTRATION_FEE
require_env MIN_PRIZE
require_env MIN_REG_TIME

log "Setting feesReceiver=$FEES_RECEIVER"
mxpy contract call "$SC_ADDRESS" --function setFeesReceiver \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments "$FEES_RECEIVER" --send --recall-nonce

log "Setting prizesReceiver=$PRIZES_RECEIVER"
mxpy contract call "$SC_ADDRESS" --function setPrizesReceiver \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments "$PRIZES_RECEIVER" --send --recall-nonce

log "Setting accepted token: $TOKEN_ID"
mxpy contract call "$SC_ADDRESS" --function setToken \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments "str:$TOKEN_ID" --send --recall-nonce

log "Setting minRegistrationFee=$MIN_REGISTRATION_FEE"
mxpy contract call "$SC_ADDRESS" --function setMinRegistrationFee \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments "$MIN_REGISTRATION_FEE" --send --recall-nonce

log "Setting minPrize=$MIN_PRIZE"
mxpy contract call "$SC_ADDRESS" --function setMinPrize \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments "$MIN_PRIZE" --send --recall-nonce

log "Setting minRegistrationTime=$MIN_REG_TIME"
mxpy contract call "$SC_ADDRESS" --function setMinRegistrationTime \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments "$MIN_REG_TIME" --send --recall-nonce

# Optional: whitelist a creator (CREATOR_WHITELIST)
if [ -n "${CREATOR_WHITELIST:-}" ]; then
  log "Whitelisting: $CREATOR_WHITELIST"
  mxpy contract call "$SC_ADDRESS" --function addWhitelisted \
    --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
    --arguments "$CREATOR_WHITELIST" --send --recall-nonce
fi

log "✅ Init complete for $SC_ADDRESS"
