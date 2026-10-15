# Troubleshooting

## Orders never appear

The usual cause is automated trading being switched off in the terminal. The Python process can still log signals in that state.

Turn it on with either of these:

1. **Tools → Options → Expert Advisors**, then enable **Allow automated trading**.
2. The AutoTrading button on the toolbar.
3. **Ctrl+E**.

Confirm the account and the symbol both allow trading. The standard runner logs an error and stops when `trade_allowed` is false. Some multi-strategy runners print a warning and ask whether to continue.

Use a demo account while you confirm this path.

## `MT5_LOGIN is not set`

The Windows runners read credentials from `.env` in the repository root. Copy `.env.example` to `.env` and set `MT5_LOGIN`, `MT5_PASSWORD`, and `MT5_SERVER`. The server string must match the name shown in the terminal, including the broker suffix.

## `No module named MetaTrader5`

Install the Windows requirements while the terminal is installed:

```bash
pip install -r requirements.txt
```

That package is a Windows library. On macOS, install `requirements-macos.txt` and start `python3 -m mt5bot.macos.mac_multi_strategy_bot`, which simulates the book when the package is absent.

## Terminal is installed but the bot cannot connect

- Open MetaTrader 5 and log in before starting the runner.
- Set `MT5_PATH` in `.env` to the full path of `terminal64.exe` if auto-detection fails.
- Check that the symbol in `TRADING_SYMBOL` is visible in Market Watch.

## The high-frequency runner is quiet

`mt5bot/config_hft.py` logs at `WARNING`. Open `logs/hft_trading_bot.log` and the terminal's Trade tab. A quiet console with a growing log, or with new positions in the terminal, means the loop is running.

## Where files are written

| Output | Location |
| --- | --- |
| Logs | `logs/` |
| Live collection | `data/collected/` |
| ML exports | `data/ml/` |
| Shutdown performance JSON | `data/reports/` |

Earlier versions wrote these files next to the Python scripts. Current runners use the paths above.
