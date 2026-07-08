FROM ubuntu:22.04

# تعيين المتغيرات البيئية لضمان عمل الواجهة الرسومية
ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:99 \
    RESOLUTION=1280x720 \
    VNC_PASSWORD=lordsbot \
    HOME=/home/wineuser

# تحديث النظام وتثبيت Wine والواجهة الرسومية و NoVNC
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    gnupg \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    xfce4 \
    xfce4-terminal \
    supervisor \
    unzip \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y wine64 wine32 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مستخدم لتشغيل التطبيق بأمان
RUN useradd -m -s /bin/bash wineuser
WORKDIR /home/wineuser

# تحميل التطبيق من GitHub Release
RUN wget https://github.com/Ksa518n/lordsbot-web-control/releases/download/v1.0.0/app.zip \
    && unzip app.zip \
    && rm app.zip \
    && chown -R wineuser:wineuser /home/wineuser

# نسخ ملفات التكوين
COPY --chown=wineuser:wineuser supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY --chown=wineuser:wineuser start.sh /home/wineuser/start.sh

RUN chmod +x /home/wineuser/start.sh

USER wineuser

# فتح المنفذ الذي سيستخدمه Render للمتصفح
EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
