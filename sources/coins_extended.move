module test_coins_extended::coins_extended {
    use std::signer;
    use std::string::utf8;

    use aptos_framework::coin::{Self, MintCapability, BurnCapability, Coin};

    /// Represents test USDC coin.
    struct USDC {}

    /// Represents test ETH coin.
    struct ETH {}

    /// Represents DAI coin.
    struct DAI {}

    /// Storing mint/burn capabilities for `USDT` and `BTC` coins under user account.
    struct Caps<phantom CoinType> has key {
        mint: MintCapability<CoinType>,
        burn: BurnCapability<CoinType>,
    }

    /// Initializes `ETH`, `USDC`, and `DAI` coins.
    public entry fun register_coins(token_admin: &signer) {
        let (eth_b, eth_f, eth_m) =
            coin::initialize<ETH>(token_admin,
                utf8(b"ETH"), utf8(b"ETH"), 8, true);
        let (usdc_b, usdc_f, usdc_m) =
            coin::initialize<USDC>(token_admin,
                utf8(b"USDC"), utf8(b"USDC"), 6, true);
        let (dai_b, dai_f, dai_m) =
            coin::initialize<DAI>(token_admin,
                utf8(b"DAI"), utf8(b"DAI"), 6, true);

        coin::destroy_freeze_cap(eth_f);
        coin::destroy_freeze_cap(usdc_f);
        coin::destroy_freeze_cap(dai_f);

        move_to(token_admin, Caps<ETH> { mint: eth_m, burn: eth_b });
        move_to(token_admin, Caps<USDC> { mint: usdc_m, burn: usdc_b });
        move_to(token_admin, Caps<DAI> { mint: dai_m, burn: dai_b });
    }

    /// Mints new coin `CoinType` on account `acc_addr`.
    public entry fun mint_coin<CoinType>(token_admin: &signer, acc_addr: address, amount: u64) acquires Caps {
        let token_admin_addr = signer::address_of(token_admin);
        let caps = borrow_global<Caps<CoinType>>(token_admin_addr);
        let coins = coin::mint<CoinType>(amount, &caps.mint);
        coin::deposit(acc_addr, coins);
    }

    /// Burns coins
    public entry fun burn_coin<CoinType>(token_admin: &signer, coins: Coin<CoinType>) acquires Caps {
        if (coin::value(&coins) == 0) {
            coin::destroy_zero(coins);
        } else {
            let caps = borrow_global<Caps<CoinType>>(signer::address_of(token_admin));
            coin::burn(coins, &caps.burn);
        };
    }
}
