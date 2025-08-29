# Foxleague Smart Contract (MultiversX)

Rust smart contract for **Foxleague** tournaments on the MultiversX blockchain.

---

## Project layout

- `contract/src/lib.rs` — main contract implementation  
- `contract/src/types.rs` — core structs & enums  
- `contract/meta/` — meta crate for ABI generation / build tooling  
- `scripts/` — helpers to build WASM & collect ABI  
- `scripts/ops/` — deploy & ops scripts (deploy, init, create, register, status)  
- `tests/` — integration tests

---

## Build & Test

```bash
cargo fmt --all -- --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test --workspace --all-features --verbose
```

### Artifacts (WASM + ABI)

```bash
# WASM
bash scripts/build-wasm.sh
# ABI
bash scripts/gen-abi.sh
```
Outputs are collected under:
- `artifacts/wasm/` — compiled `.wasm`  
- `artifacts/abi/` — `*.abi.json`, `*.mxsc.json`, `*.imports.json`, and a copy of `.wasm`

---

## Deploy

See full guide in [`docs/DEPLOY.md`](docs/DEPLOY.md).

---

## CI

- GitHub Actions runs: format, clippy, tests, **WASM build**, **ABI generation**.  
- Artifacts (WASM + ABI) are attached to each PR build.  
- Release workflow attaches artifacts to GitHub Releases for tags like `vX.Y.Z`.

---

## License

MIT. See `LICENSE` (or update this if you use another license).
