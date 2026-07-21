#!/bin/bash
# تهيئة Wine
export WINEPREFIX=/home/wineuser/.wine
export WINEARCH=win32
export DISPLAY=:99

# الانتظار حتى تفتح الواجهة الرسومية (Xvfb)
echo "Waiting for Xvfb..."
until xset -q -display :99 > /dev/null 2>&1
do
    echo "Xvfb is not ready yet, waiting..."
    sleep 2
done

echo "Xvfb is ready. Starting LordsMobileBot..."
cd /home/wineuser/app
wine LordsMobileBot.exe
