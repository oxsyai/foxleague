#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
source "$HERE/common.sh"

# Ensure artifacts exist; build if missing
if [ ! -f "$ART_WASM" ]; then
  log "WASM not found, building via Makefile…"
  make wasm
fi

require_env MX_WALLET
require_env MX_NETWORK
require_env SUPER_USER        # bech32 address to set as superUser

OUT_DIR="scripts/ops/out/deploy-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT_DIR"

log "Deploying to $MX_NETWORK with superUser=$SUPER_USER"
mxpy contract deploy \
  --bytecode "$ART_WASM" \
  --pem "$MX_WALLET" \
  --network "$MX_NETWORK" \
  --gas-limit=120000000 \
  --upgradeable \
  --recall-nonce \
  --send \
  --arguments "$SUPER_USER" \
  --out "$OUT_DIR"

# Try to read the contract address
ADDR="$(jq -r '.contractAddress // .scAddress // empty' "$OUT_DIR/deployTransaction.json")"
[ -n "$ADDR" ] || die "Could not parse contract address from $OUT_DIR/deployTransaction.json"

save_address "$ADDR"

log "✅ Deployed: $ADDR"
echo "$ADDR"
