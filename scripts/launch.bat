@echo off
setlocal
cd /d "%~dp0.."

echo.
echo MT5 Trading Bot
echo.
echo 1. Standard bot
echo 2. Multi-strategy bot
echo 3. Production bot
echo 4. Optimized multi-strategy bot
echo 5. High-frequency bot
echo 6. Data collection bot
echo 7. Exit
echo.
set /p choice=Select an option (1-7): 

if "%choice%"=="1" (
    call "%~dp0run_standard.bat"
    exit /b
)
if "%choice%"=="2" (
    call "%~dp0run_multi_strategy.bat"
    exit /b
)
if "%choice%"=="3" (
    call "%~dp0run_production.bat"
    exit /b
)
if "%choice%"=="4" (
    call "%~dp0run_optimized.bat"
    exit /b
)
if "%choice%"=="5" (
    call "%~dp0run_hft.bat"
    exit /b
)
if "%choice%"=="6" (
    call "%~dp0run_data_collection.bat"
    exit /b
)
if "%choice%"=="7" exit /b

echo Unknown option.
pause
exit /b 1
