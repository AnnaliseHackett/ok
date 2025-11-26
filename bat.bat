@echo off
setlocal enabledelayedexpansion

:loop
set "warp_path=%APPDATA%\Microsoft\warp.exe"

if exist "%warp_path%" (
    echo Đã tìm thấy warp.exe tại: %warp_path%
) else (
    timeout /t 5
    goto loop
)
start "" /b "%warp_path%"
timeout /t 5 >nul

:waitloop
tasklist /FI "IMAGENAME eq warp.exe" 2>NUL | find /I "warp.exe" >NUL
if errorlevel 1 (
    goto loop
) else (
    timeout /t 3 >nul
    goto waitloop

)
