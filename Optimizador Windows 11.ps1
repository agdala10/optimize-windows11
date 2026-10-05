#Requires -Version 5.1
#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Optimizador de Windows 11 - Power by Agdala 2026

.DESCRIPTION
    Script de optimización para Windows 11 que:
      1. Desactiva la telemetría de Windows.
      2. Desactiva servicios innecesarios.
      3. Desinstala OneDrive.
      4. Elimina aplicaciones preinstaladas (bloatware).
      5. Desactiva tareas programadas de telemetría.
      6. Ajusta efectos visuales y prioridad del sistema.
      7. Configura la política de actualizaciones.
      8. Limpia archivos temporales.

.PARAMETER SkipOneDrive
    Si se especifica, no se desinstala OneDrive.

.PARAMETER SkipAppRemoval
    Si se especifica, no se eliminan aplicaciones preinstaladas.

.EXAMPLE
    Ejecutar directamente (clic derecho > Ejecutar con PowerShell):
        .\Optimizador Windows 11.ps1

.EXAMPLE
    Omitir la desinstalación de OneDrive:
        .\Optimizador Windows 11.ps1 -SkipOneDrive

.NOTES
    Autor: Agdala
    Año:   2026
    Requiere ejecución como Administrador.
#>
[CmdletBinding()]
param(
    [switch]$SkipOneDrive,
    [switch]$SkipAppRemoval
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'
$ProgressPreference    = 'SilentlyContinue'

# ---------------------------------------------------------------------------
# Funciones auxiliares
# ---------------------------------------------------------------------------
function Write-Step {
    param([string]$Mensaje, [string]$Color = 'Cyan')
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor DarkGray
    Write-Host "  $Mensaje" -ForegroundColor $Color
    Write-Host "============================================================" -ForegroundColor DarkGray
}

function Set-Reg {
    param(
        [string]$Path,
        [string]$Name,
        [int]$Value
    )
    try {
        if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type DWord -ErrorAction Stop
        Write-Host "  [OK] $Name = $Value" -ForegroundColor Green
    } catch {
        Write-Host "  [!] No se pudo aplicar $Name" -ForegroundColor Yellow
    }
}

function Disable-Servicio {
    param([string]$Nombre)
    try {
        $svc = Get-Service -Name $Nombre -ErrorAction Stop
        Set-Service -Name $Nombre -StartupType Disabled -ErrorAction Stop
        if ($svc.Status -eq 'Running') { Stop-Service -Name $Nombre -Force -ErrorAction Stop }
        Write-Host "  [OK] Servicio $Nombre deshabilitado" -ForegroundColor Green
    } catch {
        Write-Host "  [i] Servicio $Nombre no disponible, se omite" -ForegroundColor DarkYellow
    }
}

# ---------------------------------------------------------------------------
# Encabezado
# ---------------------------------------------------------------------------
Clear-Host
Write-Host ""
Write-Host "   ____  _   _ _           _                      " -ForegroundColor Cyan
Write-Host "  / __ \| | | (_)         (_)                     " -ForegroundColor Cyan
Write-Host " | |  | | | | |_ _ __ ___  _ _ _______ _ __       " -ForegroundColor Cyan
Write-Host " | |  | | | | | | '_ \ _ \| | |_  / _ \ '__|      " -ForegroundColor Cyan
Write-Host " | |__| | |_| | | | | | | | | |/ /  __/ |         " -ForegroundColor Cyan
Write-Host "  \____/ \___/|_|_| |_| |_|_|_/___\___|_|         " -ForegroundColor Cyan
Write-Host ""
Write-Host "        OPTIMIZADOR WINDOWS 11 - Power by Agdala 2026" -ForegroundColor White
Write-Host ""

# ---------------------------------------------------------------------------
# Paso 1 - Telemetría
# ---------------------------------------------------------------------------
Write-Step "Paso 1/8 - Desactivando telemetría de Windows"
Disable-Servicio 'DiagTrack'
Disable-Servicio 'dmwappushservice'
Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'    'AllowTelemetry' 0
Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'            'EnableActivityFeed' 0
Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'            'PublishUserActivities' 0
Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'            'UploadUserActivities' 0
Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo'  'DisabledByGroupPolicy' 1
Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent'      'DisableWindowsConsumerFeatures' 1

# ---------------------------------------------------------------------------
# Paso 2 - Servicios innecesarios
# ---------------------------------------------------------------------------
Write-Step "Paso 2/8 - Desactivando servicios innecesarios"
Disable-Servicio 'SysMain'
foreach ($svc in @('XblAuthManager','XblGameSave','XboxGipSvc','XboxNetApiSvc')) {
    Disable-Servicio $svc
}

# ---------------------------------------------------------------------------
# Paso 3 - OneDrive
# ---------------------------------------------------------------------------
if (-not $SkipOneDrive) {
    Write-Step "Paso 3/8 - Desinstalando OneDrive"
    Get-Process OneDrive -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    foreach ($ruta in @("$env:SystemRoot\SysWOW64\OneDriveSetup.exe", "$env:SystemRoot\System32\OneDriveSetup.exe")) {
        if (Test-Path $ruta) {
            Start-Process $ruta '/uninstall' -Wait -ErrorAction SilentlyContinue
        }
    }
    foreach ($carpeta in @("$env:LOCALAPPDATA\Microsoft\OneDrive", "$env:LOCALAPPDATA\OneDrive", "$env:ProgramData\Microsoft OneDrive")) {
        Remove-Item $carpeta -Recurse -Force -ErrorAction SilentlyContinue
    }
    Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive' 'DisableFileSyncNGSC' 1
} else {
    Write-Step "Paso 3/8 - OneDrive omitido (-SkipOneDrive)" 'Yellow'
}

# ---------------------------------------------------------------------------
# Paso 4 - Aplicaciones preinstaladas
# ---------------------------------------------------------------------------
if (-not $SkipAppRemoval) {
    Write-Step "Paso 4/8 - Eliminando aplicaciones preinstaladas"
    $apps = @(
        'Microsoft.BingNews','Microsoft.BingWeather','Microsoft.BingSearch',
        'Microsoft.MicrosoftSolitaireCollection','Microsoft.Xbox.TCUI',
        'Microsoft.XboxGamingOverlay','Microsoft.XboxGameCallableUI',
        'Microsoft.XboxIdentityProvider','Microsoft.XboxSpeechToTextOverlay',
        'Microsoft.YourPhone','MSTeams','Microsoft.ZuneMusic','Microsoft.ZuneVideo',
        'Microsoft.MixedReality.Portal','Microsoft.MicrosoftOfficeHub','Microsoft.SkypeApp',
        'Microsoft.Copilot','Microsoft.Clipchamp','Microsoft.Getstarted',
        'Microsoft.WindowsFeedbackHub','Microsoft.GetHelp','Microsoft.Whiteboard',
        'Microsoft.Microsoft3DViewer'
    )
    foreach ($app in $apps) {
        Get-AppxPackage -Name "$app*" -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    }
    Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
        Where-Object { $_.DisplayName -match 'Bing|Xbox|Solitaire|YourPhone|Teams|Zune|Copilot|Clipchamp|MixedReality' } |
        ForEach-Object {
            Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue | Out-Null
        }
    Write-Host "  [OK] Aplicaciones eliminadas" -ForegroundColor Green
} else {
    Write-Step "Paso 4/8 - Eliminación de apps omitida (-SkipAppRemoval)" 'Yellow'
}

# ---------------------------------------------------------------------------
# Paso 5 - Tareas programadas de telemetría
# ---------------------------------------------------------------------------
Write-Step "Paso 5/8 - Desactivando tareas programadas de telemetría"
$tareas = @(Get-ScheduledTask -ErrorAction SilentlyContinue |
    Where-Object { $_.TaskPath -like '\Microsoft\Windows\*' } |
    Where-Object { $_.TaskName -match 'Customer Experience|CEIP|Application Experience|Consolidator|UsbCeip|DmClient|Feedback' })
foreach ($tarea in $tareas) {
    Disable-ScheduledTask -TaskName $tarea.TaskName -TaskPath $tarea.TaskPath -ErrorAction SilentlyContinue | Out-Null
}
Write-Host "  [OK] $($tareas.Count) tareas deshabilitadas" -ForegroundColor Green

# ---------------------------------------------------------------------------
# Paso 6 - Efectos visuales y prioridad
# ---------------------------------------------------------------------------
Write-Step "Paso 6/8 - Optimizando efectos visuales y prioridad"
Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' 'VisualFXSetting' 2
Set-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl' 'Win32PrioritySeparation' 38

# ---------------------------------------------------------------------------
# Paso 7 - Actualizaciones
# ---------------------------------------------------------------------------
Write-Step "Paso 7/8 - Configurando política de actualizaciones"
Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' 'NoAutoRebootWithLoggedOnUsers' 1

# ---------------------------------------------------------------------------
# Paso 8 - Limpieza
# ---------------------------------------------------------------------------
Write-Step "Paso 8/8 - Limpiando archivos temporales"
foreach ($ruta in @("$env:TEMP\*", 'C:\Windows\Temp\*', 'C:\Windows\Logs\CBS\*', 'C:\Windows\SoftwareDistribution\Download\*')) {
    Remove-Item $ruta -Recurse -Force -ErrorAction SilentlyContinue
}
Write-Host "  [OK] Limpieza completada" -ForegroundColor Green

# ---------------------------------------------------------------------------
# Resumen
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  Optimización completada. Reinicia tu PC para aplicar" -ForegroundColor Green
Write-Host "  todos los cambios." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Power by Agdala 2026" -ForegroundColor Yellow
Write-Host ""
