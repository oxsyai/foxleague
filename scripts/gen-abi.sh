#!/usr/bin/env bash
set -euo pipefail
cargo run -p foxleague-sc-meta -- abi
echo "ABI   -> meta/output/"
