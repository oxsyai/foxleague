#!/usr/bin/env bash
set -euo pipefail
rustup target add wasm32-unknown-unknown >/dev/null 2>&1 || true
cargo build -p foxleague-sc --release --target wasm32-unknown-unknown
echo "WASM -> target/wasm32-unknown-unknown/release/foxleague_sc.wasm"
