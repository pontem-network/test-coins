#[test_only]
module test_coins::coins_extended_tests {
    use std::signer;
    use std::string::utf8;

    use aptos_framework::coin;
    use test_coins_extended::coins_extended::{ETH, DAI, USDC, register_coins, mint_coin};
    use aptos_framework::genesis;
    use aptos_framework::aptos_account::create_account;


    #[test(token_admin = @test_token_extended_admin)]
    fun test_register_coins(token_admin: signer) {
        genesis::setup();
        create_account(signer::address_of(&token_admin));

        register_coins(&token_admin);

        assert!(coin::is_coin_initialized<ETH>(), 0);
        assert!(coin::is_coin_initialized<USDC>(), 1);
        assert!(coin::is_coin_initialized<DAI>(), 2);

        assert!(coin::name<ETH>() == utf8(b"ETH"), 3);
        assert!(coin::symbol<ETH>() == utf8(b"ETH"), 4);
        assert!(coin::decimals<ETH>() == 8, 5);

        assert!(coin::name<USDC>() == utf8(b"USDC"), 6);
        assert!(coin::symbol<USDC>() == utf8(b"USDC"), 7);
        assert!(coin::decimals<USDC>() == 6, 8);

        assert!(coin::name<DAI>() == utf8(b"DAI"), 9);
        assert!(coin::symbol<DAI>() == utf8(b"DAI"), 10);
        assert!(coin::decimals<DAI>() == 6, 11);
    }

    #[test(token_admin = @test_token_extended_admin, eth_owner = @test_eth_owner)]
    fun test_mint_coin(token_admin: signer, eth_owner: signer) {
        genesis::setup();
        create_account(signer::address_of(&token_admin));
        create_account(signer::address_of(&eth_owner));

        register_coins(&token_admin);

        coin::register<ETH>(&eth_owner);

        mint_coin<ETH>(&token_admin, signer::address_of(&eth_owner), 100000000);

        assert!(coin::balance<ETH>(signer::address_of(&eth_owner)) == 100000000, 0);
    }
}