# mt5-xauusd-bot

A MetaTrader 5 trading system that reads market data from a local terminal, evaluates it with technical strategies, and submits orders through a shared risk layer.

Live order flow is built for Windows, where the official `MetaTrader5` Python package can talk to the terminal. The macOS runner uses the same idea and falls back to a simulated book when that package is not available. Use a demo account until you have reviewed the strategy parameters and risk limits.

## Requirements

- Windows 10 or later, with the MetaTrader 5 terminal installed and logged in
- Python 3.10 or newer
- Automated trading enabled in the terminal before you expect orders to fill

## Install

From the repository root:

```bash
py -3 -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
copy .env.example .env
```

Set these values in `.env`:

| Variable | Purpose |
| --- | --- |
| `MT5_LOGIN` | Account number |
| `MT5_PASSWORD` | Account password |
| `MT5_SERVER` | Broker server name |
| `MT5_PATH` | Optional path to `terminal64.exe` |
| `TRADING_SYMBOL` | Default `XAUUSD` |
| `TRADING_TIMEFRAME` | Default `M5` for the standard bot |
| `DEFAULT_LOT_SIZE` | Default `0.01` |

The repository does not ship with a login or password. `.env` is ignored by git.

## Run

Start the terminal, then from the repository root:

```bash
py -3 -m mt5bot.runners.main
```

On Windows you can also use `scripts\launch.bat`, which activates `venv` or `trading_bot_env` when one of those folders exists.

Enable automated trading in MetaTrader 5 before expecting fills: **Tools → Options → Expert Advisors → Allow automated trading**, or press **Ctrl+E**. If that switch is off, the bot can still compute signals while the terminal rejects orders. See [docs/troubleshooting.md](docs/troubleshooting.md).

### Runners

| Command | What it does |
| --- | --- |
| `py -3 -m mt5bot.runners.main` | One strategy, selected by `active_strategy` in `mt5bot/config.py`. Default is EMA crossover on M5. |
| `py -3 -m mt5bot.runners.multi_strategy_bot` | Five strategies on M1 XAUUSD, each with its own position cap. |
| `py -3 -m mt5bot.runners.production_multi_strategy` | Aggressive scalp and momentum breakout, with per-strategy position limits. |
| `py -3 -m mt5bot.runners.optimized_multi_strategy` | The five-strategy set with tighter loop and position handling. |
| `py -3 -m mt5bot.runners.hft_main` | 50 ms loop using `mt5bot/config_hft.py` and the HFT EMA scalper. |
| `py -3 -m mt5bot.runners.data_collection_bot` | Records live bars and features under `data/collected`. Does not trade. |
| `py -3 -m mt5bot.runners.data_collector` | Interactive historical and tick export under `data/ml/training`. |
| `py -3 -m mt5bot.runners.simple_data_collection` | Shorter one-second collection loop. Writes to `data/ml`. |
| `py -3 -m mt5bot.macos.mac_multi_strategy_bot` | macOS entry point. Simulates fills when MetaTrader 5 cannot be imported. |

Stop a runner with Ctrl+C. The multi-strategy runners write a performance snapshot to `data/reports` on shutdown.

## Project layout

```text
.
├── mt5bot/
│   ├── config.py              Standard session, risk, and strategy settings
│   ├── config_hft.py          Tighter settings for the high-frequency runner
│   ├── paths.py               Repository paths for logs and data
│   ├── core/                  Terminal connection, orders, and risk checks
│   ├── strategies/            Signal generators
│   ├── runners/               Processes you actually start
│   └── macos/                 macOS connector and runner
├── scripts/                   Windows launchers and the macOS setup script
├── tests/                     Offline strategy checks and speed probes
├── docs/                      Architecture, HFT notes, macOS setup, troubleshooting
├── data/                      Collected bars, ML exports, and performance reports
└── logs/                      Runtime logs
```

## Strategies

Every strategy subclasses `BaseStrategy` and returns `BUY`, `SELL`, or no signal from OHLC bars.

| Strategy | Module | Used by |
| --- | --- | --- |
| EMA crossover | `ema_crossover.py` | Standard bot, multi-strategy, optimized |
| RSI divergence | `rsi_divergence.py` | Standard bot |
| Bollinger scalp | `bollinger_scalp.py` | Standard bot |
| Stochastic momentum | `stochastic_momentum.py` | Standard bot |
| MACD signal cross | `macd_signal_cross.py` | Standard bot |
| Aggressive scalp | `aggressive_scalp.py` | Multi-strategy, production, optimized |
| Momentum breakout | `momentum_breakout.py` | Multi-strategy, production, optimized |
| Mean reversion | `mean_reversion.py` | Multi-strategy, optimized |
| HFT EMA scalper | `hft_ema_scalper.py` | Multi-strategy, optimized, HFT runner |

Change the standard bot's strategy with `STRATEGY_SETTINGS['active_strategy']` in `mt5bot/config.py`. The multi-strategy runners construct their own strategy list in code.

## Risk defaults

`mt5bot/config.py` is the standard profile:

- 1% of balance risked per trade
- 5% maximum daily loss
- 10% maximum drawdown
- 15 open positions across the account
- 5-pip stop and 10-pip target as the default gold distances
- Trailing stop enabled

`RiskManager` and `TradeManager` read `mt5bot/config.py` for every Windows runner. `mt5bot/config_hft.py` supplies the HFT runner's loop interval (50 ms), timeframe (M1), and lot size. The position and loss caps written in `config_hft.py` are kept with that profile for reference; the shared risk layer does not load them yet. Read both files before running on a funded account. Per-strategy caps in the multi-strategy runners can be stricter than the global cap.

## Logs and data

| Path | Contents |
| --- | --- |
| `logs/` | Runner logs |
| `data/collected/` | Live collection bot output |
| `data/ml/` | Feature exports for later research |
| `data/reports/` | JSON snapshots written when a multi-strategy runner stops |

`data/reports/optimized_multi_strategy_performance_20250830_013000.json` is a saved session file. It is a record of one run, not a performance target.

## Tests

These checks do not send orders:

```bash
py -3 tests/test_strategies.py
py -3 tests/test_setup.py
```

`test_setup.py` loads `.env` and, on Windows, checks that the MetaTrader 5 package imports. `tests/speed_test.py` and `tests/hft_debug.py` time the live terminal path, so they need a running terminal.

## macOS

```bash
pip3 install -r requirements-macos.txt
python3 -m mt5bot.macos.mac_multi_strategy_bot
```

`scripts/deploy_macos.sh` creates a virtual environment and writes `run_mac_bot.sh` in the repository root. Details are in [docs/macos.md](docs/macos.md).

## Further reading

- [Architecture](docs/architecture.md)
- [High-frequency runner](docs/hft.md)
- [macOS setup](docs/macos.md)
- [Troubleshooting](docs/troubleshooting.md)

## Disclaimer

This software is for education and research. Trading foreign exchange and CFDs can lose the entire amount you commit, and more where your broker allows it. Nothing in this repository is a recommendation to trade. Review every order rule on a demo account first.
