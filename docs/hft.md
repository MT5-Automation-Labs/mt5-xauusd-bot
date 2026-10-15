# High-frequency runner

`mt5bot/runners/hft_main.py` is a separate process with its own settings file, `mt5bot/config_hft.py`. It does not read the intervals in `mt5bot/config.py`.

## What the runner uses from `config_hft.py`

| Setting | Value used by `hft_main.py` |
| --- | --- |
| Update interval | 50 ms |
| Timeframe | M1 |
| Symbol | `TRADING_SYMBOL`, default `XAUUSD` |
| Order size | `DEFAULT_LOT_SIZE`, default 0.01 |
| Log level | `WARNING`, written to `logs/hft_trading_bot.log` |
| Strategy parameters | The `ema_crossover` block, passed into `HFTEMAScalper` |

`HFTEMAScalper` defaults to a 3-period and an 8-period EMA, with ATR-based stops (`mt5bot/strategies/hft_ema_scalper.py`). Keys in the `ema_crossover` block that the class does not recognize are ignored.

Account-level limits still come from `mt5bot/config.py`, because `RiskManager` and `TradeManager` import that module. The 3-position cap, 0.5% risk, 3% daily-loss cap, and 5% drawdown cap inside `config_hft.py` document the intended HFT profile. They are not applied until those core classes are pointed at the HFT settings.

## Start

1. Log in to a demo account in MetaTrader 5.
2. Enable automated trading (see [troubleshooting.md](troubleshooting.md)).
3. From the repository root, with `.env` filled in:

```bash
py -3 -m mt5bot.runners.hft_main
```

Or run `scripts\run_hft.bat`.

The standard bot (`mt5bot.runners.main`) remains available when you want the 200 ms profile and a single slower strategy. The HFT runner is the one that uses the 50 ms profile.

## Operating notes

A short loop produces more signals than a swing strategy. The risk file is tighter for that reason, and it is still only a starting point. Watch spread, stop distance, and the broker's minimum stop level on XAUUSD before leaving the process unattended.

`tests/speed_test.py` measures data retrieval and strategy time against a live terminal. `tests/hft_debug.py` prints the current market state and can run a monitored loop. Both need the terminal open and `.env` configured.
