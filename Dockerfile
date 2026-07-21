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
    git \
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
    x11-utils \
    dbus-x11 \
    libxv1 \
    xdotool \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y wine64 wine32 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# تثبيت noVNC بشكل يدوي لضمان المسارات
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html

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

# إعداد ملفات X11 للمستخدم
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

USER wineuser

# فتح المنفذ الذي سيستخدمه Render للمتصفح
EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
