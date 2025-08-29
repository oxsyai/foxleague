#!/usr/bin/env bash
set -euo pipefail

# Load local .env if present (alongside this file)
ENV_FILE="$(dirname "$0")/.env"
[ -f "$ENV_FILE" ] && source "$ENV_FILE"

log()  { echo -e "[$(date -u +%H:%M:%S)] $*"; }
die()  { echo -e "❌ $*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

require_env() {
  local name="$1"
  [ -n "${!name:-}" ] || die "Missing required env: $name"
}

# Tooling checks
have mxpy || die "mxpy not found. Install MultiversX CLI and ensure it’s on PATH."
have jq   || die "jq not found. Install: sudo apt-get install -y jq"

# Network + Wallet
export MX_NETWORK="${MX_NETWORK:-devnet}"     # devnet|testnet|mainnet
require_env MX_WALLET                         # path to PEM (or --keyfile usage if you prefer)

# Useful paths
ART_WASM="artifacts/wasm/foxleague-sc.wasm"
ART_ABI_DIR="artifacts/abi"

# Contract address cache
ADDR_FILE="scripts/ops/.contract-address"
save_address() { echo -n "$1" > "$ADDR_FILE"; }
load_address() { [ -f "$ADDR_FILE" ] && cat "$ADDR_FILE" || true; }
