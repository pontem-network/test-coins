#[test_only]
module test_coins::coins_tests {
    use std::string::utf8;
    use aptos_framework::account::create_account_for_test;
    use aptos_framework::coin;
    use aptos_framework::genesis;

    use test_coins::coins::{BTC, USDT, register_coins, mint_coin, ETH, USDC, DAI};

    #[test]
    fun test_register_coins() {
        genesis::setup();
        let token_admin = &create_account_for_test(@test_token_admin);

        register_coins(token_admin);

        assert!(coin::is_coin_initialized<BTC>(), 0);
        assert!(coin::is_coin_initialized<USDT>(), 1);
        assert!(coin::is_coin_initialized<ETH>(), 0);
        assert!(coin::is_coin_initialized<USDC>(), 1);
        assert!(coin::is_coin_initialized<DAI>(), 2);

        assert!(coin::name<ETH>() == utf8(b"Ethereum"), 3);
        assert!(coin::symbol<ETH>() == utf8(b"ETH"), 4);
        assert!(coin::decimals<ETH>() == 8, 5);

        assert!(coin::name<USDC>() == utf8(b"USD Coin"), 6);
        assert!(coin::symbol<USDC>() == utf8(b"USDC"), 7);
        assert!(coin::decimals<USDC>() == 6, 8);

        assert!(coin::name<DAI>() == utf8(b"DAI"), 9);
        assert!(coin::symbol<DAI>() == utf8(b"DAI"), 10);
        assert!(coin::decimals<DAI>() == 6, 11);

        assert!(coin::name<BTC>() == utf8(b"Bitcoin"), 2);
        assert!(coin::symbol<BTC>() == utf8(b"BTC"), 3);
        assert!(coin::decimals<BTC>() == 8, 4);

        assert!(coin::name<USDT>() == utf8(b"Tether"), 5);
        assert!(coin::symbol<USDT>() == utf8(b"USDT"), 6);
        assert!(coin::decimals<USDT>() == 6, 7);
    }

    #[test]
    fun test_mint_coin() {
        genesis::setup();
        let token_admin = &create_account_for_test(@test_token_admin);
        let account_address = @test_account;

        register_coins(token_admin);

        let test_account = &create_account_for_test(@test_account);

        coin::register<ETH>(test_account);
        mint_coin<ETH>(token_admin, account_address, 100000000);
        assert!(coin::balance<ETH>(account_address) == 100000000, 0);

        coin::register<USDC>(test_account);
        mint_coin<USDC>(token_admin, account_address, 1000000);
        assert!(coin::balance<USDC>(account_address) == 1000000, 1);

        coin::register<DAI>(test_account);
        mint_coin<DAI>(token_admin, account_address, 1000000);
        assert!(coin::balance<DAI>(account_address) == 1000000, 1);

        coin::register<BTC>(test_account);
        mint_coin<BTC>(token_admin, account_address, 100000000);
        assert!(coin::balance<BTC>(account_address) == 100000000, 0);

        coin::register<USDT>(test_account);
        mint_coin<USDT>(token_admin, account_address, 1000000);
        assert!(coin::balance<USDT>(account_address) == 1000000, 1);
    }
}