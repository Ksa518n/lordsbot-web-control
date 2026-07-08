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
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y wine64 wine32 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مستخدم لتشغيل التطبيق بأمان
RUN useradd -m -s /bin/bash wineuser
WORKDIR /home/wineuser

# نسخ ملفات التطبيق
COPY --chown=wineuser:wineuser app /home/wineuser/app
COPY --chown=wineuser:wineuser supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY --chown=wineuser:wineuser start.sh /home/wineuser/start.sh

RUN chmod +x /home/wineuser/start.sh

USER wineuser

# فتح المنفذ الذي سيستخدمه Render للمتصفح
EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
