@echo off
setlocal
cd /d "%~dp0.."
call "%~dp0_activate.bat"
echo Starting the production bot. Enable AutoTrading in MetaTrader 5 before expecting orders.
call "%~dp0_python.bat" -m mt5bot.runners.production_multi_strategy
pause
