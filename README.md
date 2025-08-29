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
