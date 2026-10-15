@echo off
setlocal
cd /d "%~dp0.."
call "%~dp0_activate.bat"
echo Starting data collection. Output is written to data\collected.
call "%~dp0_python.bat" -m mt5bot.runners.data_collection_bot
pause
