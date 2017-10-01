@echo off
setlocal enabledelayedexpansion
title Uninstall PDF Lock Context Menu
echo 🔧 Removing 'Lock PDF with Password' context menu...

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️ Administrator privileges required. Requesting elevation...
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d \"%~dp0\" && \"%~f0\"' -Verb RunAs"
    exit /b 0
)

echo ✅ Running with Administrator privileges...

echo 🔍 Checking if registry key exists...
reg query "HKEY_CLASSES_ROOT\SystemFileAssociations\.pdf\shell\LockWithPassword" >nul 2>&1
if %errorlevel% equ 0 (
    echo 📍 Found registry key, proceeding with removal...
) else (
    echo ℹ️ Registry key not found - may already be uninstalled.
    echo ✅ Uninstall complete (nothing to remove).
    pause
    exit /b 0
)

set REG_FILE=%TEMP%\remove_lockpdf.reg

> "%REG_FILE%" echo Windows Registry Editor Version 5.00
>>"%REG_FILE%" echo.
>>"%REG_FILE%" echo [-HKEY_CLASSES_ROOT\SystemFileAssociations\.pdf\shell\LockWithPassword]

echo 🧹 Cleaning up registry entry...
regedit /s "%REG_FILE%" 2>nul

reg query "HKEY_CLASSES_ROOT\SystemFileAssociations\.pdf\shell\LockWithPassword" >nul 2>&1
if %errorlevel% neq 0 (
    echo ✅ Registry key successfully removed.
) else (
    echo ❌ Failed to remove registry key completely.
    pause
    exit /b 1
)

del "%REG_FILE%" 2>nul
echo ✅ Context menu removed successfully.
pause
