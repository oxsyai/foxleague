# ---- Foxleague Makefile ----
# Usage examples:
#   make help
#   make test
#   make wasm
#   make abi
#   make ci
#   make release-tag VERSION=0.1.1

SHELL := /bin/bash
VERSION ?= 0.0.0

# Paths
WASM     := artifacts/wasm/foxleague-sc.wasm
ABI_DIR  := artifacts/abi
META_BIN := contract/meta/../../target/debug/foxleague-sc-meta

.PHONY: help
help:
	@echo "Targets:"
	@echo "  make fmt            - Check formatting"
	@echo "  make clippy         - Clippy (warnings as errors)"
	@echo "  make test           - Run workspace tests"
	@echo "  make wasm           - Build release WASM"
	@echo "  make abi            - Generate ABI (into $(ABI_DIR))"
	@echo "  make ci             - fmt + clippy + test + wasm + abi"
	@echo "  make clean          - Clean target + artifacts"
	@echo "  make release-tag VERSION=X.Y.Z - Tag vX.Y.Z (after bumping Cargo.toml)"

.PHONY: fmt
fmt:
	cargo fmt --all -- --check

.PHONY: clippy
clippy:
	cargo clippy --all-targets --all-features -- -D warnings

.PHONY: test
test:
	cargo test --workspace --all-features --verbose

.PHONY: wasm
wasm:
	bash scripts/build-wasm.sh
	@ls -la $(WASM) || { echo "WASM not found at $(WASM)"; exit 1; }

.PHONY: abi
abi:
	bash scripts/gen-abi.sh
	@ls -la $(ABI_DIR) || { echo "ABI folder not found at $(ABI_DIR)"; exit 1; }

.PHONY: ci
ci: fmt clippy test wasm abi
	@echo "✅ CI steps done locally."

.PHONY: clean
clean:
	cargo clean
	rm -rf $(ABI_DIR) output contract/output

.PHONY: release-tag
release-tag:
	@if [[ "$(VERSION)" == "0.0.0" ]]; then echo "Set VERSION=X.Y.Z"; exit 1; fi
	git tag -a v$(VERSION) -m "Foxleague SC $(VERSION)"
	git push --tags
	@echo "🚀 Pushed tag v$(VERSION). GitHub Action 'Release' will build & attach WASM + ABI."
