#!/usr/bin/env bash
set -euo pipefail

# Build the meta binary from the workspace
cargo build -p foxleague-sc-meta

# Run the MVX builder from contract/meta
pushd contract/meta >/dev/null
../../target/debug/foxleague-sc-meta build
popd >/dev/null

# Collect the produced .wasm into a stable artifacts path
mkdir -p artifacts/wasm

# Known output locations for MVX meta build:
# - contract/output/*.wasm
# - output/*.wasm (rare)
WASM_SRC=""
if compgen -G "contract/output/*.wasm" > /dev/null; then
  WASM_SRC=$(ls -1 contract/output/*.wasm | head -n1)
elif compgen -G "output/*.wasm" > /dev/null; then
  WASM_SRC=$(ls -1 output/*.wasm | head -n1)
fi

if [[ -z "${WASM_SRC}" ]]; then
  echo "❌ Could not find built .wasm under contract/output or output" >&2
  exit 1
fi

cp -f "${WASM_SRC}" artifacts/wasm/
echo "WASM -> $(pwd)/artifacts/wasm/$(basename "${WASM_SRC}")"
