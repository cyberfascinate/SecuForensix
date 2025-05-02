@echo off
chcp 65001 >nul
title SecuForensix v1.1.0 - Windows Forensics Tool
setlocal EnableDelayedExpansion

:: Define color output function
set "psout=powershell -Command"

:: Print header
%psout% "Write-Host 'SecuForensix v1.1.0 - Windows Forensics Tool' -ForegroundColor Cyan"
echo.

:: Set output directory with timestamp
set timestamp=%date%_%time%
set timestamp=%timestamp::=-%
set timestamp=%timestamp:/=-%
set timestamp=%timestamp: =_%
set output_dir="C:\ForensicReports\%timestamp%"
mkdir %output_dir%
cd %output_dir%

%psout% "Write-Host '[*] Initializing forensic analysis...' -ForegroundColor Yellow"
timeout /t 1 >nul

:: Check if ADB is installed
where adb >nul 2>&1
if %errorlevel% neq 0 (
    %psout% "Write-Host '[!] ADB not found. Attempting to download ADB...' -ForegroundColor Red"
    timeout /t 1 >nul

    :: Clean old ADB if it exists
    %psout% "Write-Host '[*] Cleaning up old ADB directory if it exists...' -ForegroundColor Yellow"
    powershell -Command "if (Test-Path 'C:\platform-tools') { Remove-Item -Path 'C:\platform-tools' -Recurse -Force -ErrorAction SilentlyContinue }"

    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/android/repository/platform-tools-latest-windows.zip', 'C:\platform-tools-latest-windows.zip')"

    if exist "C:\platform-tools-latest-windows.zip" (
        %psout% "Write-Host '[✓] ADB downloaded successfully.' -ForegroundColor Green"
        timeout /t 1 >nul

        %psout% "Write-Host '[*] Extracting ADB...' -ForegroundColor Yellow"
        powershell -Command "Expand-Archive -Path 'C:\platform-tools-latest-windows.zip' -DestinationPath 'C:\platform-tools' -Force"
        %psout% "Write-Host '[✓] ADB extracted to C:\platform-tools.' -ForegroundColor Green"
        set adb_path=C:\platform-tools
    ) else (
        %psout% "Write-Host '[!] Error downloading ADB. Please download it manually.' -ForegroundColor Red"
        pause
        exit /b
    )
) else (
    %psout% "Write-Host '[✓] ADB is already installed.' -ForegroundColor Green"
    set adb_path=%CD%
)

:: Add the ADB path to system PATH temporarily
set PATH=%adb_path%;%PATH%

:: Check required tools
where wevtutil >nul 2>&1
if %errorlevel% neq 0 (
    %psout% "Write-Host '[!] Error: wevtutil not found. Ensure it is in your system path.' -ForegroundColor Red"
    pause
    exit /b
)

where netstat >nul 2>&1
if %errorlevel% neq 0 (
    %psout% "Write-Host '[!] Error: netstat not found. Ensure it is in your system path.' -ForegroundColor Red"
    pause
    exit /b
)

:: Prompt user
call :ask_user "Do you want to collect system logs?" "collect_logs"
call :ask_user "Do you want to collect network connections?" "collect_network"
call :ask_user "Do you want to collect Android device data?" "collect_android"

:: Done
%psout% "Write-Host '[✓] Forensic analysis complete.' -ForegroundColor Cyan"
%psout% "Write-Host '[✓] Report and logs saved to: %output_dir%' -ForegroundColor Green"
echo.
pause
exit /b

:: Prompt function
:ask_user
setlocal
set message=%~1
set label=%~2
:ask
%psout% "Write-Host '[+]' -NoNewline -ForegroundColor Cyan"
echo %message% (Y/N)
set /p response=Choose: 
if /i "%response%"=="Y" (
    call :%label%
) else if /i "%response%"=="N" (
    %psout% "Write-Host '[!] Skipping %label%.' -ForegroundColor DarkYellow"
) else (
    %psout% "Write-Host '[!] Invalid input, please enter Y or N.' -ForegroundColor Red"
    goto ask
)
endlocal
exit /b

:: System logs
:collect_logs
%psout% "Write-Host '[*] Collecting system logs...' -ForegroundColor Yellow"
timeout /t 1 >nul
wevtutil qe System /f:text > system_log.txt
wevtutil qe Application /f:text > app_log.txt
wevtutil qe Security /f:text > security_log.txt
%psout% "Write-Host '[✓] System logs saved: system_log.txt, app_log.txt, security_log.txt' -ForegroundColor Green"
exit /b

:: Network
:collect_network
%psout% "Write-Host '[*] Collecting network connections...' -ForegroundColor Yellow"
timeout /t 1 >nul
netstat -ano > network_connections.txt
%psout% "Write-Host '[✓] Network connections saved: network_connections.txt' -ForegroundColor Green"
exit /b

:: Android
:collect_android
%psout% "Write-Host '[*] Collecting Android device data...' -ForegroundColor Yellow"
timeout /t 1 >nul
adb devices > android_devices.txt
if %errorlevel% neq 0 (
    %psout% "Write-Host '[!] Error: No Android devices found or ADB failed to connect.' -ForegroundColor Red"
    exit /b
)
adb pull /data/data > android_data.txt
%psout% "Write-Host '[✓] Android data saved: android_devices.txt, android_data.txt' -ForegroundColor Green"
exit /b
