# Foxleague SC — Deploy & Init (MultiversX)

This guide shows two ways to deploy & operate the contract:

- **Quickstart (scripts/ops)** – shortest path using the provided ops scripts  
- **Raw `mxpy` commands** – full commands using MultiversX CLI directly

Artifacts built by CI (and locally via Makefile):
- **WASM**: `artifacts/wasm/foxleague-sc.wasm`
- **ABI bundle**: `artifacts/abi/{foxleague-sc.abi.json, foxleague-sc.mxsc.json, foxleague-sc.imports.json, foxleague-sc.wasm}`

---

## 0) Build artifacts (local)

```bash
make wasm
make abi

1) Quickstart (scripts/ops)

Tip: copy scripts/ops/.env.example → scripts/ops/.env and fill values to avoid long commands.

# 1) Deploy (prints & caches address at scripts/ops/.contract-address)
SUPER_USER=erd1... MX_NETWORK=devnet MX_WALLET=~/wallets/owner.pem \
scripts/ops/deploy.sh

# 2) Init (owner-only)
FEES_RECEIVER=erd1... PRIZES_RECEIVER=erd1... TOKEN_ID=FOXSY-xxxxxx \
MIN_REGISTRATION_FEE=1000000000000000000 MIN_PRIZE=100000000000000000000 \
MIN_REG_TIME=86400 MX_NETWORK=devnet MX_WALLET=~/wallets/owner.pem \
scripts/ops/init.sh

# 3) Create a tournament (sends prize in accepted ESDT)
T_ID=1 REG_FEE=10000000000000000000 PRIZE=1000000000000000000000 \
TOKEN_ID=FOXSY-xxxxxx MX_NETWORK=devnet MX_WALLET=~/wallets/owner.pem \
scripts/ops/create_tournament.sh

# 4) Register (pays fee in accepted ESDT; excess refunded)
TOURNAMENT_ID=1 TEAM_SETUP_ID=42 FEE_AMOUNT=10000000000000000000 \
TOKEN_ID=FOXSY-xxxxxx MX_NETWORK=devnet MX_WALLET=~/wallets/owner.pem \
scripts/ops/register.sh

# 5) Read-only status (no wallet needed)
MX_NETWORK=devnet scripts/ops/status.sh

2) Raw mxpy commands
Prereqs
python3 -m pip install -U multiversx-sdk-cli jq
export MX_NETWORK=devnet         # or: testnet | mainnet
export MX_WALLET=~/wallets/owner.pem
mxpy --version
mxpy wallet bech32 --pem "$MX_WALLET"

Deploy (init takes super_user)
export SUPER_USER=erd1....................................

mxpy contract deploy \
  --bytecode artifacts/wasm/foxleague-sc.wasm \
  --pem "$MX_WALLET" \
  --network "$MX_NETWORK" \
  --gas-limit=120000000 \
  --upgradeable \
  --recall-nonce \
  --send \
  --arguments "$SUPER_USER" \
  --out ./deploy-out

# read the deployed address
export SC_ADDRESS=$(jq -r '.contractAddress // .scAddress' ./deploy-out/deployTransaction.json)
echo "$SC_ADDRESS"

Owner configuration (set once per deployment)
# receivers
mxpy contract call $SC_ADDRESS --function setFeesReceiver \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments erd1... --send --recall-nonce

mxpy contract call $SC_ADDRESS --function setPrizesReceiver \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments erd1... --send --recall-nonce

# accepted token (ESDT identifier, e.g., FOXSY-xxxxxx)
mxpy contract call $SC_ADDRESS --function setToken \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments str:FOXSY-xxxxxx --send --recall-nonce

# minimums (BigUint/u64)
mxpy contract call $SC_ADDRESS --function setMinRegistrationFee \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments 1000000000000000000 --send --recall-nonce

mxpy contract call $SC_ADDRESS --function setMinPrize \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments 100000000000000000000 --send --recall-nonce

mxpy contract call $SC_ADDRESS --function setMinRegistrationTime \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments 86400 --send --recall-nonce

# whitelist a creator (optional)
mxpy contract call $SC_ADDRESS --function addWhitelisted \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=20000000 \
  --arguments erd1... --send --recall-nonce

Views (sanity)
mxpy contract query $SC_ADDRESS --function getAcceptedToken       --network "$MX_NETWORK"
mxpy contract query $SC_ADDRESS --function getMinPrize            --network "$MX_NETWORK"
mxpy contract query $SC_ADDRESS --function getMinRegistrationTime --network "$MX_NETWORK"
mxpy contract query $SC_ADDRESS --function getOpenTournaments     --network "$MX_NETWORK"

Create a tournament (prize ESDT payment)
export T_ID=1
export NOW=$(date -u +%s)
export START=$((NOW + 2*3600))
export END=$((NOW + 3*24*3600))
export REG_FEE=10000000000000000000     # 10 tokens (18 dec)
export PRIZE=1000000000000000000000     # 1000 tokens (18 dec)
export TOKEN=FOXSY-xxxxxx

mxpy contract call $SC_ADDRESS --function createTournament \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=90000000 --recall-nonce --send \
  --arguments $T_ID $START $END $REG_FEE \
  --token $TOKEN --amount $PRIZE

Register (fee ESDT payment)
export TOURNAMENT_ID=1
export TEAM_SETUP_ID=42
export FEE_TO_SEND=$REG_FEE   # >= registration_fee; excess refunded

mxpy contract call $SC_ADDRESS --function register \
  --pem "$MX_WALLET" --network "$MX_NETWORK" --gas-limit=60000000 --recall-nonce --send \
  --arguments $TOURNAMENT_ID $TEAM_SETUP_ID \
  --token $TOKEN --amount $FEE_TO_SEND

Notes & Troubleshooting

Amounts are integers scaled by token decimals (e.g., 1 token @ 18 dec → 1000000000000000000).

Enforce end - start >= minRegistrationTime, start > now.

“Wrong token” → run setToken(FOXSY-xxxxxx) with the exact ESDT id.

“Not whitelisted” on create → addWhitelisted(creator).

CI already builds & uploads artifacts for each PR/release.
