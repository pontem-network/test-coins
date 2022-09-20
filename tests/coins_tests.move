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

        assert!(coin::name<BTC>() == utf8(b"Bitcoin"), 2);
        assert!(coin::symbol<BTC>() == utf8(b"BTC"), 3);
        assert!(coin::decimals<BTC>() == 8, 4);

        assert!(coin::name<USDT>() == utf8(b"Tether"), 5);
        assert!(coin::symbol<USDT>() == utf8(b"USDT"), 6);
        assert!(coin::decimals<USDT>() == 6, 7);
    }

    #[test(token_admin = @test_token_admin, test_account = @test_account)]
    fun test_mint_coin(token_admin: signer, test_account: signer) {
        let account_address = signer::address_of(&test_account);

        genesis::setup();
        create_account(signer::address_of(&token_admin));
        create_account(account_address);

        register_coins(&token_admin);

        coin::register<BTC>(&test_account);
        mint_coin<BTC>(&token_admin, account_address, 100000000);
        assert!(coin::balance<BTC>(account_address) == 100000000, 0);

        coin::register<USDT>(&test_account);
        mint_coin<USDT>(&token_admin, account_address, 1000000);
        assert!(coin::balance<USDT>(account_address) == 1000000, 1);
    }
}