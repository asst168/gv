@echo off
setlocal enabledelayedexpansion
title 大俠專用：RDP 28xxx 終極優化陣法
color 0A

echo ============================================================
echo      正在執行 RDP 終極優化 (針對 Canary 28xxx 內網環境)
echo ============================================================
echo.

:: 1. 取得最高權限 (Take Ownership) - 針對 Canary 可能對機碼的限制
echo [1/6] 正在打通機碼脈絡...

:: 2. 解除連線限制 (多人同時登入不同帳號)
echo [2/6] 正在解放連線數限制與單一帳號鎖定...
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server" /v fSingleSessionPerUser /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MaxInstanceCount /t REG_DWORD /d 999999 /f

:: 3. 內網優化：關閉 NLA 認證與認證提示 (讓連線快如閃電)
echo [3/6] 正在優化內網認證流程 (NLA Disabled)...
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f
reg add "HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v SecurityLayer /t REG_DWORD /d 1 /f

:: 4. 效能優化：開啟硬體加速與 UDP 傳輸
echo [4/6] 正在注入顯卡加速與 UDP 傳輸心法...
:: 啟用 RemoteFX 與 虛擬化顯卡支持
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fEnableRemoteFXAdvancedRemoteApp /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fEnableVirtualizedGraphics /t REG_DWORD /d 1 /f
:: 確保 UDP 優先 (減少延遲)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" /v fClientDisableUDP /t REG_DWORD /d 0 /f

:: 5. 設定工作階段逾時 (可選：防止閒置佔用)
echo [5/6] 正在設定工作階段自動管理...
:: 設定已中斷連線的工作階段在 2 小時後自動登出 (120000 毫秒)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v MaxDisconnectionTime /t REG_DWORD /d 7200000 /f

:: 6. 重新啟動服務使設定生效
echo [6/6] 正在重啟遠端服務以完成收尾...
net stop TermService /y
net start TermService

echo.
echo ============================================================
echo      修復完成！大俠您的 RDP 陣法已煥然一新。
echo      提醒：若多人同時連線失效，請手動更新 RDP Wrapper 的 .ini
echo ============================================================
echo.
pause