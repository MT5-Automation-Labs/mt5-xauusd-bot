@echo off
where py >nul 2>&1
if %errorlevel%==0 (
    py -3 %*
) else (
    python %*
)
