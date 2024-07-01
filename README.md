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
rev = 'main'
```

And use in code:

```move
use test_coins::coins::{USDT, BTC, USDC, ETH, DAI};
```

### Build

[Aptos CLI](https://github.com/aptos-labs/aptos-core/releases) required:

    aptos move compile

### Test

    aptos move test

### License

MIT.