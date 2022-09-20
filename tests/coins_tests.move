#[test_only]
module test_coins::coins_tests {
    use std::signer;
    use std::string::utf8;

    use aptos_framework::coin;
    use test_coins::coins::{BTC, USDT, register_coins, mint_coin};
    use aptos_framework::genesis;
    use aptos_framework::aptos_account::create_account;


    #[test(token_admin = @test_token_admin)]
    fun test_register_coins(token_admin: signer) {
        genesis::setup();
        create_account(signer::address_of(&token_admin));

        register_coins(&token_admin);

        assert!(coin::is_coin_initialized<BTC>(), 0);
        assert!(coin::is_coin_initialized<USDT>(), 1);
    }

    #[test(token_admin = @test_token_admin, btc_owner = @test_btc_owner)]
    fun test_mint_coin(token_admin: signer, btc_owner: signer) {
        genesis::setup();
        create_account(signer::address_of(&token_admin));
        create_account(signer::address_of(&btc_owner));

        register_coins(&token_admin);

        coin::register<BTC>(&btc_owner);

        mint_coin<BTC>(&token_admin, signer::address_of(&btc_owner), 100000000);

        assert!(coin::name<BTC>() == utf8(b"Bitcoin"), 0);
    }
}