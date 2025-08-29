// types.rs
use multiversx_sc::api::ManagedTypeApi;
use multiversx_sc::derive_imports::*;
use multiversx_sc::types::{BigUint, ManagedAddress, ManagedVec};

#[type_abi]
#[derive(NestedEncode, NestedDecode, TopEncode, TopDecode, PartialEq, Clone, ManagedVecItem)]
pub enum TournamentStatus {
    Active,
    Cancelled,
    Closed,
}

#[type_abi]
#[derive(NestedEncode, NestedDecode, TopEncode, TopDecode, PartialEq, Clone, ManagedVecItem)]
pub struct Registration<M: ManagedTypeApi> {
    pub address: ManagedAddress<M>,
    pub team_setup_id: BigUint<M>,
}

#[type_abi]
#[derive(NestedEncode, NestedDecode, TopEncode, TopDecode, PartialEq, Clone, ManagedVecItem)]
pub struct Tournament<M: ManagedTypeApi> {
    pub tournament_id: BigUint<M>,
    pub utc_registration_start: u64,
    pub utc_registration_end: u64,
    pub registration_fee: BigUint<M>,
    pub registration_cancelation_fee: BigUint<M>,
    pub prize: BigUint<M>,
    pub status: TournamentStatus,
    pub creator_address: ManagedAddress<M>,
    pub registrations: ManagedVec<M, Registration<M>>,
}
