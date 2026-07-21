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

# إنشاء مجلد Wine إذا لم يكن موجوداً
if [ ! -d "$WINEPREFIX" ]; then
    echo "Initializing Wine prefix..."
    winecfg > /dev/null 2>&1
    sleep 5
fi

cd /home/wineuser/app
# تشغيل البوت مع إبقاء السكربت يعمل حتى لو فشل البوت مؤقتاً
wine LordsMobileBot.exe || echo "Bot exited with error code $?"

# إبقاء السكربت يعمل لمنع supervisord من إعادة التشغيل السريعة جداً
sleep 10
