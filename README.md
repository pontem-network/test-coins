# Test Coins for Liquidswap

The smart contracts contain deployed coins for tests purposes.

* BTC
* USDT
* ETH
* DAI
* USDC

## Add as dependency

Update your `Move.toml` with

```toml
[dependencies.TestCoins]
git = 'https://github.com/pontem-network/test-coins.git'
rev = 'v0.1.1'
```

And use in code:

```move
use test_coins::coins::{USDT, BTC};
use test_coins_extended::extended_coins::{USDC, ETH, DAI};
...
```

### Build

[Aptos CLI](https://github.com/aptos-labs/aptos-core/releases) required:

    aptos move compile

### License

MIT.