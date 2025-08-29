#!/usr/bin/env bash
set -euo pipefail

# Ensure wasm target on runner
rustup target add wasm32-unknown-unknown >/dev/null 2>&1 || true

# Build meta binary
cargo build -p foxleague-sc-meta

# MultiversX meta build (produces contract/output/*)
pushd contract/meta >/dev/null
../../target/debug/foxleague-sc-meta build
popd >/dev/null

# Collect artifact
mkdir -p artifacts/wasm
WASM_SRC=""
if compgen -G "contract/output/*.wasm" > /dev/null; then
  WASM_SRC=$(ls -1 contract/output/*.wasm | head -n1)
elif compgen -G "output/*.wasm" > /dev/null; then
  WASM_SRC=$(ls -1 output/*.wasm | head -n1)
fi
if [[ -z "${WASM_SRC}" ]]; then
  echo "❌ No .wasm found under contract/output or output" >&2
  echo "Hint: ensure 'binaryen' (wasm-opt) is installed and wasm32 target is added." >&2
  exit 1
fi
cp -f "${WASM_SRC}" artifacts/wasm/foxleague-sc.wasm
echo "WASM -> $(pwd)/artifacts/wasm/foxleague-sc.wasm"
