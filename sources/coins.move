module test_coins::coins {
    use std::signer;
    use std::string::utf8;

    use aptos_std::type_info;
    use aptos_framework::coin::{Self, MintCapability, BurnCapability, Coin};

    use test_coins_extended::coins_extended::{Self, ETH, DAI, USDC};

    /// Represents test USDT coin.
    struct USDT {}

    /// Represents test BTC coin.
    struct BTC {}

    /// Storing mint/burn capabilities for `USDT` and `BTC` coins under user account.
    struct Caps<phantom CoinType> has key {
        mint: MintCapability<CoinType>,
        burn: BurnCapability<CoinType>,
    }

    /// Initializes `BTC` and `USDT` coins.
    public entry fun register_coins(token_admin: &signer) {
        let (btc_b, btc_f, btc_m) =
            coin::initialize<BTC>(token_admin,
                utf8(b"Bitcoin"), utf8(b"BTC"), 8, true);
        let (usdt_b, usdt_f, usdt_m) =
            coin::initialize<USDT>(token_admin,
                utf8(b"Tether"), utf8(b"USDT"), 6, true);

        coin::destroy_freeze_cap(btc_f);
        coin::destroy_freeze_cap(usdt_f);

        move_to(token_admin, Caps<BTC> { mint: btc_m, burn: btc_b });
        move_to(token_admin, Caps<USDT> { mint: usdt_m, burn: usdt_b });
    }

    public fun mint<CoinType>(token_admin: &signer, amount: u64): Coin<CoinType> acquires Caps {
        if (is_extended_coin<CoinType>()) {
            coins_extended::mint<CoinType>(token_admin, amount)
        } else {
            let token_admin_addr = signer::address_of(token_admin);
            let caps = borrow_global<Caps<CoinType>>(token_admin_addr);
            coin::mint<CoinType>(amount, &caps.mint)
        }
    }

    public fun burn<CoinType>(token_admin: &signer, coins: Coin<CoinType>) acquires Caps {
        if (coin::value(&coins) == 0) {
            coin::destroy_zero(coins);
            return
        };
        if (is_extended_coin<CoinType>()) {
            coins_extended::burn(token_admin, coins);
        } else {
            let token_admin_addr = signer::address_of(token_admin);
            let caps = borrow_global<Caps<CoinType>>(token_admin_addr);
            coin::burn<CoinType>(coins, &caps.burn);
        }
    }

    /// Mints new coin `CoinType` on account `acc_addr`.
    public entry fun mint_coin<CoinType>(token_admin: &signer, acc_addr: address, amount: u64) acquires Caps {
        let token_admin_addr = signer::address_of(token_admin);
        let caps = borrow_global<Caps<CoinType>>(token_admin_addr);
        let coins = coin::mint<CoinType>(amount, &caps.mint);
        coin::deposit(acc_addr, coins);
    }

    public fun store_caps<CoinType>(
        token_admin: &signer,
        mint_cap: MintCapability<CoinType>,
        burn_cap: BurnCapability<CoinType>
    ) {
        move_to(
            token_admin,
            Caps { mint: mint_cap, burn: burn_cap }
        );
    }

    fun is_extended_coin<CoinType>(): bool {
        return type_info::type_of<CoinType>() == type_info::type_of<ETH>()
            || type_info::type_of<CoinType>() == type_info::type_of<DAI>()
            || type_info::type_of<CoinType>() == type_info::type_of<USDC>()
    }
}
