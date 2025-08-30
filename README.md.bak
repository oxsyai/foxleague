# Foxleague Smart Contract (MultiversX)

🦊 **Foxleague** is a Rust smart contract built on the MultiversX blockchain to manage decentralized tournaments with on-chain registration, prize pools, and rules enforcement.

---

## Key Concepts

### 🔐 Access Control
- `super_user` – contract owner
- `authorized_erds` – list of authorized accounts
- `whitelisted_erds` – accounts allowed to create tournaments

### ⚙ Configuration (set & view)
- `min_registration_fee` – minimum fee required
- `min_tournament_prize` – minimum prize pool in $FOXSY
- `min_registration_time` – minimum time between registration start and end
- `accepted_token` – ESDT token accepted for fees/prizes
- `fees_receiver` – address receiving registration fees
- `prizes_receiver` – address receiving tournament prizes

### 🏆 Tournament Lifecycle
- **Create Tournament**  
  Parameters:  
  - `id: BigInt`  
  - `utc_registration_start: u64`  
  - `utc_registration_end: u64`  
  - `registration_fee: BigUint`  
  - `prize: BigUint` (funded in $FOXSY at creation)  
  - `status: Active | Cancelled | Closed`

- **Update Tournament**  
  - Add more $FOXSY to prize pool  
  - Change registration fee (before start)  
  - Adjust UTC start/end times  

- **Cancel Tournament**  
  - Allowed only for Owner or Authorized ERDs before start  

- **Register**  
  - Pay registration fee in accepted token  
  - Optionally cancel with a fee deduction  

### 👁 Views
- `getTournamentById(id)`  
- `getTournamentsByCreator(address)`  
- `getTournamentsByStatus(status)`  
- `getOpenTournaments()`  
- Utility views for super user, fees receiver, prize receiver, token, and config values  

---

## Layout
- `src/types.rs` – core structs & enums
- `src/lib.rs` – main contract implementation
- `docs/` – additional specifications & whitepaper

---

## Build & Test

```bash
cargo check
cargo build

---

## Deploy & Ops Quickstart

See full guide in [`docs/DEPLOY.md`](docs/DEPLOY.md). TL;DR:

```bash
# 0) Build artifacts
make wasm
make abi

# 1) Deploy (prints & caches contract address to scripts/ops/.contract-address)
SUPER_USER=erd1... MX_NETWORK=devnet MX_WALLET=~/wallets/owner.pem \
scripts/ops/deploy.sh

# 2) Init (owner-only config)
FEES_RECEIVER=erd1... PRIZES_RECEIVER=erd1... TOKEN_ID=FOXSY-xxxxxx \
MIN_REGISTRATION_FEE=1000000000000000000 MIN_PRIZE=100000000000000000000 \
MIN_REG_TIME=86400 MX_NETWORK=devnet MX_WALLET=~/wallets/owner.pem \
scripts/ops/init.sh

# 3) Create a tournament (sends prize ESDT)
T_ID=1 REG_FEE=10000000000000000000 PRIZE=1000000000000000000000 \
TOKEN_ID=FOXSY-xxxxxx MX_NETWORK=devnet MX_WALLET=~/wallets/owner.pem \
scripts/ops/create_tournament.sh

# 4) Register (sends fee ESDT)
TOURNAMENT_ID=1 TEAM_SETUP_ID=42 FEE_AMOUNT=10000000000000000000 \
TOKEN_ID=FOXSY-xxxxxx MX_NETWORK=devnet MX_WALLET=~/wallets/owner.pem \
scripts/ops/register.sh

