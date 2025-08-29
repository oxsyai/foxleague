#!/usr/bin/env bash
set -euo pipefail

# Build the meta binary
cargo build -p foxleague-sc-meta

# Run from contract/meta (ABI lands in output folder)
pushd contract/meta >/dev/null
../../target/debug/foxleague-sc-meta abi
popd >/dev/null

# Collect ABI to stable path
mkdir -p artifacts/abi
for d in contract/meta/output contract/output output; do
  [ -d "$d" ] && cp -rf "$d"/* artifacts/abi/ 2>/dev/null || true
done

echo "ABI -> $(pwd)/artifacts/abi"
ls -la artifacts/abi || true
