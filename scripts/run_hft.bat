@echo off
setlocal
cd /d "%~dp0.."
call "%~dp0_activate.bat"
echo Starting the high-frequency bot. Use a demo account and enable AutoTrading in MetaTrader 5.
call "%~dp0_python.bat" -m mt5bot.runners.hft_main
pause
