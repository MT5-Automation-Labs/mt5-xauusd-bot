@echo off
setlocal
cd /d "%~dp0.."
call "%~dp0_activate.bat"
echo Starting the multi-strategy bot. Enable AutoTrading in MetaTrader 5 before expecting orders.
call "%~dp0_python.bat" -m mt5bot.runners.multi_strategy_bot
pause
