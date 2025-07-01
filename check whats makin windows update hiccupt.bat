@echo off
echo Searching for Windows Update blocking registry policies...
echo.

REM Check NoAutoUpdate policy
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\MicrosoftfffWindows\WindowsUpdate\AU" /v NoAutoUpdate >nul 2>&1
if %errorLevel% equ 0 (
    echo [FOUND] NoAutoUpdate policy - This disables automatic updates
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate
    echo.
) else (
    echo [OK] NoAutoUpdate policy not found
)

REM Check SetDisableUXWUAccess policy
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v SetDisableUXWUAccess >nul 2>&1
if %errorLevel% equ 0 (
    echo [FOUND] SetDisableUXWUAccess policy - This removes Windows Update UI access
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v SetDisableUXWUAccess
    echo.
) else (
    echo [OK] SetDisableUXWUAccess policy not found
)

REM Check DisableOSUpgrade policy
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableOSUpgrade >nul 2>&1
if %errorLevel% equ 0 (
    echo [FOUND] DisableOSUpgrade policy - This blocks OS version upgrades
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DisableOSUpgrade
    echo.
) else (
    echo [OK] DisableOSUpgrade policy not found
)

REM Check TargetReleaseVersion policy
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v TargetReleaseVersion >nul 2>&1
if %errorLevel% equ 0 (
    echo [FOUND] TargetReleaseVersion policy - This pins to specific Windows version
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v TargetReleaseVersion
    echo.
) else (
    echo [OK] TargetReleaseVersion policy not found
)

REM Check ProductVersion policy
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ProductVersion >nul 2>&1
if %errorLevel% equ 0 (
    echo [FOUND] ProductVersion policy - This specifies Windows version to stay on
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v ProductVersion
    echo.
) else (
    echo [OK] ProductVersion policy not found
)

REM Check TargetReleaseVersionInfo policy
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v TargetReleaseVersionInfo >nul 2>&1
if %errorLevel% equ 0 (
    echo [FOUND] TargetReleaseVersionInfo policy - This specifies target release info
    reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v TargetReleaseVersionInfo
    echo.
) else (
    echo [OK] TargetReleaseVersionInfo policy not found
)

echo.
echo Registry search complete!
echo Any policies marked as [FOUND] may be interfering with Windows Updates.
echo.
pause
