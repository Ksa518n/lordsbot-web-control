#!/bin/bash
# تهيئة Wine
export WINEPREFIX=/home/wineuser/.wine
export WINEARCH=win32
export DISPLAY=:99

# الانتظار حتى تفتح الواجهة الرسومية (Xvfb)
echo "Waiting for Xvfb on DISPLAY :99..."
for i in {1..30}; do
    if xset -q -display :99 > /dev/null 2>&1; then
        echo "Xvfb is ready!"
        break
    fi
    echo "Waiting for Xvfb... ($i/30)"
    sleep 2
done

# التأكد من وجود مدير النوافذ (اختياري ولكن يساعد Wine)
if ! pgrep -x "xfwm4" > /dev/null; then
    echo "Starting window manager..."
    xfwm4 --daemon
fi

echo "Starting LordsMobileBot..."

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
