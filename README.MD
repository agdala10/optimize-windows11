# # Optimizador Windows 11 - PowerShell

## Pasos para usar

1. Clic derecho en "Optimizador Windows 11.ps1" y elije "Ejecutar con PowerShell".
2. O, alternativa: copia todo el código PowerShell que dejó el archivo.
3. Abre PowerShell como Administrador.
4. Pega el script completo y presiona Enter.
5. Espera a que termine y reinicia el equipo.

\n\n\n
******************************************************************
      *     Power by Agdala 2026  ·  has fingeringkui
******************************************************************


## Código listo para pegar en PowerShell Administrador

`powershell
#Requires -RunAsAdministrator
$ProgressPreference = "SilentlyContinue"
# =====================================================================================
#         OPTIMIZADOR WINDOWS 11 - POWER BY AGDALA 2026
# =====================================================================================
Write-Host "=== Optimizador Windows 11 by Agdala 2026 ===" -ForegroundColor Cyan
# -------- 1. Desactivar telemetría --------
Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue
Set-Service dmwappushservice -StartupType Disabled -ErrorAction SilentlyContinue
Stop-Service dmwappushservice -Force -ErrorAction SilentlyContinue
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 0 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Value 0 -Type DWord
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Value 1 -Type DWord
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord
# -------- 2. Desactivar servicios innecesarios --------
Set-Service SysMain -StartupType Disabled -ErrorAction SilentlyContinue
Stop-Service SysMain -Force -ErrorAction SilentlyContinue
foreach ($svc in @("XblAuthManager","XblGameSave","XboxGipSvc","XboxNetApiSvc")) {
    Set-Service $svc -StartupType Disabled -ErrorAction SilentlyContinue
    Stop-Service $svc -Force -ErrorAction SilentlyContinue
}
# -------- 3. Eliminar OneDrive --------
Get-Process OneDrive -ErrorAction SilentlyContinue | Stop-Process -Force
$oneDriveSetup = "$env:SystemRoot\SysWOW64\OneDriveSetup.exe"
if (Test-Path $oneDriveSetup) { Start-Process $oneDriveSetup "/uninstall" -Wait }
$oneDriveSetup32 = "$env:SystemRoot\System32\OneDriveSetup.exe"
if (Test-Path $oneDriveSetup32) { Start-Process $oneDriveSetup32 "/uninstall" -Wait }
Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1 -Type DWord
# -------- 4. Eliminar apps preinstaladas --------
$apps = @("Microsoft.BingNews","Microsoft.BingWeather","Microsoft.BingSearch","Microsoft.MicrosoftSolitaireCollection","Microsoft.Xbox.TCUI","Microsoft.XboxGamingOverlay","Microsoft.XboxGameCallableUI","Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay","Microsoft.YourPhone","MSTeams","Microsoft.ZuneMusic","Microsoft.ZuneVideo","Microsoft.MixedReality.Portal","Microsoft.MicrosoftOfficeHub","Microsoft.SkypeApp","Microsoft.Copilot","Microsoft.Clipchamp","Microsoft.Getstarted","Microsoft.WindowsFeedbackHub","Microsoft.GetHelp","Microsoft.Whiteboard","Microsoft.Microsoft3DViewer")
foreach ($app in $apps) { Get-AppxPackage -Name "$app*" | Remove-AppxPackage -ErrorAction SilentlyContinue }
Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -match "Bing|Xbox|Solitaire|YourPhone|Teams|Zune|Copilot|Clipchamp|MixedReality" } | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue | Out-Null }
# -------- 5. Desactivar tareas programadas telemetría --------
$t = Get-ScheduledTask | Where-Object { $_.TaskPath -like "\Microsoft\Windows\*" } | Where-Object { $_.TaskName -match "Customer Experience|CEIP|Application Experience|Consolidator|UsbCeip|DmClient|Feedback" }
foreach ($task in $t) { Disable-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath -ErrorAction SilentlyContinue | Out-Null }
# -------- 6. Efectos visuales y prioridad --------
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -ErrorAction SilentlyContinue
# -------- 7. Actualizaciones --------
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Type DWord
# -------- 8. Limpieza --------
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\Logs\CBS\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Optimización completada. Reinicia tu PC." -ForegroundColor Green
Write-Host "Power by Agdala 2026" -ForegroundColor Yellow

`$adorno
