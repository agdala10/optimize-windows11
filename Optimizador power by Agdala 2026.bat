@echo off
title Optimizador Power by Agdala 2026
color 0A
net session >nul 2>&1 || (echo Debe ejecutar como ADMINISTRADOR & pause & exit /b 1)
echo ======================================
echo   OPTIMIZADOR WINDOWS - AGDALA 2026
echo ======================================
echo.
echo [1/8] Desactivando telemetria de Windows...
sc config DiagTrack start= disabled >nul
sc stop DiagTrack >nul 2>&1
sc config dmwappushservice start= disabled >nul
sc stop dmwappushservice >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul
echo       Ok.

echo [2/8] Desactivando servicios innecesarios....
sc config SysMain start= disabled >nul
sc stop SysMain >nul 2>&1
sc config XblAuthManager start= disabled >nul
sc stop XblAuthManager >nul 2>&1
sc config XblGameSave start= disabled >nul
sc stop XblGameSave >nul 2>&1
sc config XboxGipSvc start= disabled >nul
sc stop XboxGipSvc >nul 2>&1
sc config XboxNetApiSvc start= disabled >nul
sc stop XboxNetApiSvc >nul 2>&1
echo       Ok.

echo [3/8] Desinstalando OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
if exist "%SystemRoot%\SysWOW64\OneDriveSetup.exe" %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1
if exist "%SystemRoot%\System32\OneDriveSetup.exe" %SystemRoot%\System32\OneDriveSetup.exe /uninstall >nul 2>&1
rmdir /s /q "%LOCALAPPDATA%\Microsoft\OneDrive" >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f >nul
echo       Ok.

echo [4/8] Quitando apps de Xbox y demas bloque del Store...
powershell -NoProfile -Command "Get-AppxPackage | Where-Object {$_.Name -match 'Bing|Xbox|Solitaire|YourPhone|MSTeams|Zune'} | ForEach-Object { Remove-AppxPackage -Package $_.PackageFullName -ErrorAction SilentlyContinue }"
echo       Ok.

echo [5/8] Limpiando archivos temporales...
del /f /s /q "%TEMP%\*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*" >nul 2>&1
echo       Ok.

echo [6/8] Reparando y limpiando componentes de Windows...
DISM /Online /Cleanup-Image /StartComponentCleanup
echo       Ok.

echo [7/8] Optimizando efectos visuales y prioridades...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul
echo       Ok.

echo [8/8] Finalizando...
echo       Listo.
echo.
echo Proceso terminado. Reinicie el equipo.
pause >nul
