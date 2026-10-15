# Architecture

The bot is a set of runners that share one terminal connection, one order path, and one risk check. Strategies do not send orders themselves. They read a bar dataframe and return a signal.

## Loop

A trading runner repeats the same cycle until Ctrl+C:

1. Pull recent OHLC bars for the configured symbol and timeframe.
2. Ask each enabled strategy for `BUY`, `SELL`, or no signal.
3. Ask `RiskManager` whether another position is allowed.
4. Ask `TradeManager` to send a market order with stop loss and take profit.
5. Sleep for the runner's update interval, then repeat.

The standard runner in `mt5bot/runners/main.py` loads a single strategy named by `STRATEGY_SETTINGS['active_strategy']`. Its default interval is 200 ms. The multi-strategy runners pull M1 XAUUSD bars once per loop and hand that frame to every enabled strategy.

## Components

| Module | Responsibility |
| --- | --- |
| `mt5bot/core/mt5_connector.py` | Initialize the terminal, read account and symbol state, fetch bars, and list positions. |
| `mt5bot/core/trade_manager.py` | Size, send, modify, and close orders. |
| `mt5bot/core/risk_manager.py` | Enforce position caps, daily loss, drawdown, margin, and trailing stops. |
| `mt5bot/strategies/` | Indicator logic. Each class implements `get_signal`, `get_stop_loss`, and `get_take_profit`. |
| `mt5bot/config.py` | Credentials, symbol, risk, and the standard strategy profile. Credentials come from `.env`. |
| `mt5bot/config_hft.py` | Separate profile for `mt5bot/runners/hft_main.py`. |
| `mt5bot/paths.py` | Absolute paths for `logs/` and `data/`, so output does not depend on the working directory. |

## Runners

| Runner | Strategies | Market data |
| --- | --- | --- |
| `main` | One of EMA, RSI divergence, Bollinger, stochastic, or MACD | Symbol and timeframe from `config.py` |
| `multi_strategy_bot` | EMA, aggressive scalp, momentum breakout, mean reversion, HFT EMA | XAUUSD M1 |
| `optimized_multi_strategy` | Same five as the multi-strategy bot | XAUUSD M1 |
| `production_multi_strategy` | Aggressive scalp and momentum breakout | XAUUSD M1 |
| `hft_main` | HFT EMA scalper | Profile in `config_hft.py` |
| `data_collection_bot`, `data_collector`, `simple_data_collection` | None. These processes only record data. | Live or historical bars |

Position limits inside a multi-strategy runner are per strategy. `RiskManager` still applies the account-level cap from the active config.

## macOS

`mt5bot/macos/mac_mt5_connector.py` tries to import `MetaTrader5`. When that import fails, the connector switches to an in-memory price and position book so the macOS runner can be exercised without a terminal. That book is a development stand-in. Windows plus a logged-in terminal is the path that submits broker orders.

## Extension points

Add a strategy by subclassing `BaseStrategy`, placing the module in `mt5bot/strategies/`, and registering it in the runner that should use it. The standard runner also needs an entry in the `strategy_map` inside `mt5bot/runners/main.py` and a parameter block in `STRATEGY_SETTINGS`.
