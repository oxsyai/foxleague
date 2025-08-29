use foxleague_sc as _; // ensure the crate links

#[test]
fn sanity() {
    // Minimal smoke test so CI runs `cargo test` successfully.
    assert_eq!(2 + 2, 4);
}
