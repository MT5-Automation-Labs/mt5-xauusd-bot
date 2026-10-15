# macOS setup

The Windows package `MetaTrader5` is not part of the macOS requirements. The macOS runner starts in simulation when that import is unavailable, and it looks for a Wine or application install of the terminal when you want to experiment with a real connection.

## Install

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements-macos.txt
```

Or, on macOS only:

```bash
chmod +x scripts/deploy_macos.sh
./scripts/deploy_macos.sh
```

The deploy script creates `mac_trading_env`, writes a starter `.env` if one is missing, and adds `run_mac_bot.sh` and `test_mac_setup.sh` to the repository root.

## Run

From the repository root:

```bash
python3 -m mt5bot.macos.mac_multi_strategy_bot
```

After the deploy script:

```bash
./test_mac_setup.sh
./run_mac_bot.sh
```

## Simulation

With no MetaTrader 5 module, `MacMT5Connector` keeps an in-memory account (starting balance 10,000) and a synthetic XAUUSD price. Orders update that book only. Use this mode to check that the process starts and that strategies emit signals.

## Terminal experiments

Wine is optional. The connector searches these locations:

- `/Applications/MetaTrader 5/terminal64.exe`
- `~/Applications/MetaTrader 5/terminal64.exe`
- `~/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe`
- `~/.wine/drive_c/Program Files (x86)/MetaTrader 5/terminal64.exe`

A Wine install does not make the official Python package available. Live broker orders are supported on Windows with the terminal running. Treat the macOS path as a development and simulation environment.

## Credentials

If you create `.env` by hand, the Windows runners expect `MT5_LOGIN`, `MT5_PASSWORD`, and `MT5_SERVER`. The macOS simulation path does not require them. Keep the file out of git.
