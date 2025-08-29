#!/usr/bin/env bash
set -euo pipefail

# Build the meta binary (workspace root)
cargo build -p foxleague-sc-meta

# Run ABI from contract/meta (so tool resolves the right Cargo.toml)
pushd contract/meta >/dev/null
../../target/debug/foxleague-sc-meta abi
popd >/dev/null

# Collect ABI to a stable location
mkdir -p artifacts/abi

# Known locations the tool may write to (depending on version):
# - contract/meta/output/
# - contract/output/
# - output/  (repo root)
found=0
for d in \
  "contract/meta/output" \
  "contract/output" \
  "output"
do
  if [ -d "$d" ]; then
    cp -rf "$d"/* artifacts/abi/ 2>/dev/null || true
    found=1
  fi
done

if [ "$found" -eq 0 ]; then
  echo "ABI output not found in known locations." >&2
  exit 1
fi

echo "ABI collected in: $(pwd)/artifacts/abi"
ls -la artifacts/abi || true
