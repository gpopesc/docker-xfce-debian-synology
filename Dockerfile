FROM debian:buster-slim

LABEL maintainer="gpopesc@gmail.com"

ARG DF=noninteractive
ARG LANG=en_US.UTF-8
ARG LANGUAGE=en_US.UTF-8
ARG DISPLAY=:0


ENV HOME=/root \
    DEBIAN_FRONTEND=${DF} \
    LANG=${LANG} \ 
    LANGUAGE=${LANGUAGE} \
    DISPLAY=${DISPLAY} \
    DISPLAY_WIDTH=${DISPLAY_WIDTH} \
    DISPLAY_HEIGHT=${DISPLAY_HEIGHT} \
    VNCPASS=${VNCPASS}
    


RUN apt-get update && apt-mark hold iptables && \
    apt-get install -y --no-install-recommends \
      dbus-x11 \
      psmisc \
      xdg-utils \
      x11-xserver-utils \
      x11-utils && \
    apt-get install -y --no-install-recommends \
      xfce4 && \
    apt-get install -y --no-install-recommends \
      gtk3-engines-xfce \
      libgtk-3-bin \
#      libpulse0 \
      mousepad \
      xfce4-notifyd \
      xfce4-taskmanager \
      xfce4-terminal && \
    apt-get install -y --no-install-recommends \
#      xfce4-battery-plugin \
#      xfce4-clipman-plugin \
#      xfce4-cpufreq-plugin \
      xfce4-cpugraph-plugin \
      xfce4-diskperf-plugin \
      xfce4-datetime-plugin \
      xfce4-fsguard-plugin \
      xfce4-genmon-plugin \
      xfce4-indicator-plugin \
      xfce4-netload-plugin \
#      xfce4-notes-plugin \
      xfce4-places-plugin \
#      xfce4-sensors-plugin \
#      xfce4-smartbookmark-plugin \
      xfce4-systemload-plugin \
#      xfce4-timer-plugin \
      xfce4-verve-plugin \
      xfce4-weather-plugin \
      xfce4-whiskermenu-plugin && \
    apt-get install -y --no-install-recommends \
      libxv1 \
      mesa-utils \
      mesa-utils-extra && \
    sed -i 's%<property name="ThemeName" type="string" value="Xfce"/>%<property name="ThemeName" type="string" value="Raleigh"/>%' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml


# mandatory apps
RUN apt-get update && apt-get -y install git \
      wget \
      curl \
#      net-tools \
      gnupg2 \
      python3 \
      x11vnc \
      xvfb \
      tzdata \
      xdotool \
   && rm -rf /var/lib/apt/lists/*

#optional apps, comment if you don't need
RUN apt-get update && apt-get -y install gpicview \
#                                         chromium \
#                                         xarchiver \
#                                         onboard \
#                                         putty \
#                                         firefox-esr \
#                                         sudo \
#                                         gpg-agent \
    && rm -rf /var/lib/apt/lists/*


#install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC \
        && git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify \
        && rm -rf /opt/noVNC/.git \
        && rm -rf /opt/noVNC/utils/websockify/.git 


#install lightweight browser - Palemoon
RUN wget -q -P /tmp https://download.opensuse.org/repositories/home:/stevenpusser/Debian_10/amd64/palemoon_29.2.1-1.gtk2_amd64.deb 
# get WPS office
RUN wget -q -P /tmp https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/10161/wps-office_11.1.0.10161.XA_amd64.deb 
# get icefact
RUN wget -q -P /tmp https://icesoft.ro/download/icefact_1.1.119.3-1_amd64.deb
# install all downloaded apps
RUN apt-get update && apt-get install -y /tmp/*.deb
RUN rm -f /tmp/*.deb

EXPOSE 5900 8080

WORKDIR /root/

HEALTHCHECK --interval=1m --timeout=10s CMD curl --fail http://127.0.0.1:8080/vnc.html



# Uncomment if you install chromium
# COPY ./config/chromium.txt /usr/share/applications/Chromium.desktop

RUN mkdir /opt/.vnc
COPY ./config/index.html /opt/noVNC/index.html 
COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]






