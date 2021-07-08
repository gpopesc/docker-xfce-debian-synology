#!/bin/bash
#add steven repository, enable autoupdate for palemoon
echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/Debian_10/ /' | tee /etc/apt/sources.list.d/home:stevenpusser.list 
curl -fsSL https://download.opensuse.org/repositories/home:stevenpusser/Debian_10/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_stevenpusser.gpg > /dev/null

Xvfb :0 -screen 0 ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x24 &
x11vnc -storepasswd "${VNCPASS}" /opt/.vnc/passwd &
/opt/noVNC/utils/novnc_proxy --listen 8080 &
startxfce4 &
x11vnc -noxdamage -repeat -capslock -xkb -rfbport 5900 -rfbauth /opt/.vnc/passwd -display :0 -N -forever -shared


