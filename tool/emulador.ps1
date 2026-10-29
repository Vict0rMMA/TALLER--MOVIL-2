param([switch]$Cerrar)

$sdk = "$env:LOCALAPPDATA\Android\sdk"
$adb = "$sdk\platform-tools\adb.exe"
$avd = "Medium_Phone"
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
$proyecto = Split-Path $PSScriptRoot -Parent

function Detener-Gradle {
    Push-Location "$proyecto\android"
    & .\gradlew.bat --stop | Out-Null
    Pop-Location
}

if ($Cerrar) {
    & $adb emu kill 2>$null
    Detener-Gradle
    Write-Host "Emulador y Gradle cerrados."
    exit 0
}

Detener-Gradle

$dns = Get-ChildItem 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces' |
    ForEach-Object { (Get-ItemProperty $_.PSPath).DhcpNameServer } |
    Where-Object { $_ } | ForEach-Object { $_ -split ' ' } |
    Where-Object { $_ } | Select-Object -Unique
$dns = (@($dns) + '8.8.8.8') -join ','
Write-Host "DNS del emulador: $dns"

Start-Process "$sdk\emulator\emulator.exe" -ArgumentList @(
    "-avd", $avd,
    "-memory", "1536",
    "-timezone", "America/Bogota",
    "-cores", "4",
    "-gpu", "host",
    "-no-boot-anim",
    "-no-audio",
    "-dns-server", $dns
)

Write-Host "Esperando a que arranque el emulador..."
& $adb wait-for-device
do {
    Start-Sleep -Seconds 2
    $booted = (& $adb shell getprop sys.boot_completed 2>$null) -replace '\s', ''
} while ($booted -ne '1')

Write-Host "Emulador listo. Ejecutando la app..."
Set-Location $proyecto
flutter run

Detener-Gradle
