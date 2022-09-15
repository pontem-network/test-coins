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
git = 'https://github.com/pontem-network/liquidswap.git'
rev = 'v0.1.0'
```

And use in code:

```move
use test_coins::coins::{USDT, BTC};
use test_coins::extended_coins::{USDC, ETH, DAI};
...
```

### Build

[Aptos CLI](https://github.com/aptos-labs/aptos-core/releases) required:

    aptos move compile

### License

MIT.