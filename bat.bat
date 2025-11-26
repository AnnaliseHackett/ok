@echo off
setlocal enabledelayedexpansion

:loop
rem Tìm đường dẫn tới warp.exe trong thư mục Microsoft của người dùng hiện tại
set "warp_path=%APPDATA%\Microsoft\warp.exe"

if exist "%warp_path%" (
    echo Đã tìm thấy warp.exe tại: %warp_path%
) else (
    echo Không tìm thấy warp.exe trong thư mục %APPDATA%\Microsoft
    timeout /t 5
    goto loop
)

rem Chạy warp.exe trong nền
start "" /b "%warp_path%"

rem Đợi 5 giây để warp.exe khởi động
timeout /t 5 >nul

:waitloop
tasklist /FI "IMAGENAME eq warp.exe" 2>NUL | find /I "warp.exe" >NUL
if errorlevel 1 (
    rem warp.exe đã thoát, lặp lại
    goto loop
) else (
    rem warp.exe vẫn còn chạy, đợi tiếp
    timeout /t 3 >nul
    goto waitloop
)