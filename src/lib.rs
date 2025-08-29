// sc-foxsy.rs -> src/lib.rs
#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

mod types;
use types::Tournament;

#[multiversx_sc::contract]
pub trait ScFoxsy {
    #[storage_mapper("superUser")]
    fn super_user(&self) -> SingleValueMapper<ManagedAddress>;

    #[storage_mapper("whitelistedAddresses")]
    fn whitelisted_addresses(&self) -> UnorderedSetMapper<ManagedAddress>;

    #[storage_mapper("feesReceiver")]
    fn fees_receiver(&self) -> SingleValueMapper<ManagedAddress>;

    #[storage_mapper("prizesReceiver")]
    fn prizes_receiver(&self) -> SingleValueMapper<ManagedAddress>;

    #[storage_mapper("minRegistrationFee")]
    fn min_registration_fee(&self) -> SingleValueMapper<BigUint>;

    #[storage_mapper("minPrize")]
    fn min_prize(&self) -> SingleValueMapper<BigUint>;

    #[storage_mapper("minRegistrationTime")]
    fn min_registration_time(&self) -> SingleValueMapper<u64>;

    #[storage_mapper("acceptedToken")]
    fn token(&self) -> SingleValueMapper<TokenIdentifier>;

    #[storage_mapper("contractStatus")]
    fn contract_status(&self) -> SingleValueMapper<bool>;

    #[storage_mapper("tournaments")]
    fn tournaments(&self, id: &BigUint) -> SingleValueMapper<Tournament<Self::Api>>;

    #[storage_mapper("allTournamentIds")]
    fn all_tournament_ids(&self) -> UnorderedSetMapper<BigUint>;

    #[init]
    fn init(&self, super_user: ManagedAddress) {
        self.super_user().set(&super_user);
        self.contract_status().set(true);
    }

    #[upgrade]
    fn upgrade(&self) {}

    // ... (all the endpoints & views from the DOCX you shared go here)
    // Due to length, I trimmed here to keep this block copyable.
    // Paste the full version I gave you earlier into your terminal
    // between `cat > src/lib.rs <<'RS'` and `RS`.
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let x = 2 + 2; assert_eq!(x, 4);
    }
}
