FROM debian:bookworm

LABEL maintainer="gpopesc@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive
ARG LANG=ro_RO.UTF-8
ARG LANGUAGE=ro_RO.UTF-8
ARG DISPLAY=:1


ENV HOME=/root \
    DEBIAN_FRONTEND=${DF} \
    LANG=${LANG} \ 
    LANGUAGE=${LANGUAGE} \
    DISPLAY=${DISPLAY} \
    DISPLAY_WIDTH=${DISPLAY_WIDTH} \
    DISPLAY_HEIGHT=${DISPLAY_HEIGHT} \
    VNCPASS=${VNCPASS} \
    TZ=${TZ} \
    USER_NAME=${USER_NAME} \
    USER_PASSWORD=${USER_PASSWORD} \
    UID=${UID} \
    GID=${GID}

# Update the package lists and hold iptables to prevent it from being upgraded
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
      libgtk-3-bin \
      libpulse0 \
      mousepad \
      xfce4-notifyd \
      xfce4-taskmanager \
      xfce4-terminal && \
    apt-get install -y --no-install-recommends \
      xfwm4 \
#      xfce4-battery-plugin \
#      xfce4-clipman-plugin \
      xfce4-cpufreq-plugin \
      xfce4-cpugraph-plugin \
#      xfce4-diskperf-plugin \
      xfce4-datetime-plugin \
#      xfce4-fsguard-plugin \
      xfce4-genmon-plugin \
      xfce4-indicator-plugin \
      xfce4-netload-plugin \
#      xfce4-notes-plugin \
#      xfce4-places-plugin \
#      xfce4-sensors-plugin \
#      xfce4-smartbookmark-plugin \
      xfce4-systemload-plugin \
#      xfce4-timer-plugin \
      xfce4-verve-plugin \
      xfce4-weather-plugin \
      xfce4-whiskermenu-plugin && \
    apt-get install -y --no-install-recommends \
      libxv1 \
      libglu1-mesa \
      mesa-utils \
      mesa-utils-extra && \
    sed -i 's%<property name="ThemeName" type="string" value="Xfce"/>%<property name="ThemeName" type="string" value="Raleigh"/>%' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
RUN echo "deb http://deb.debian.org/debian bookworm contrib main non-free-firmware" | tee -a /etc/apt/sources.list 


    
# Set up locales
RUN apt-get install -y locales && \
    sed -i -e "s/# $LANG.*/$LANG UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure locales && \
    update-locale LANG=$LANG



# mandatory apps
RUN apt-get update && apt-get -y install git \
      wget \
      curl \
      net-tools \
      gnupg2 \
      python3 \
      x11vnc \
      xvfb \
      tzdata \
      supervisor \
      procps \
      sudo \
      xdotool \
      cron \
#      pulseaudio \
#      pulseaudio-dlna \
#      pavucontrol-qt \
     pulseaudio-utils \
#     libasound2-plugins \
   && rm -rf /var/lib/apt/lists/*

#optional apps, comment if you don't need
RUN apt-get update && apt-get -y install putty \
                                         chromium \
                                         evince \
                                         libnotify-bin\
#                                         onboard \
#                                         firefox-esr \
#                                          krusader \
#                                          breeze-icon-theme \
#                                          filezilla \
#                                         doublecmd-qt \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get -y install bsdmainutils \
#                                         fontconfig \
                                         gtk2-* \
#                                         libpulse* \
#                                         libtool* \
#                                         libxrender* \
#                                         openssl*  \
#                                         shared-mime-info \
#                                         desktop-file-utils \
#                                         sqlite \
                                         ttf-mscorefonts-installer \
&& rm -rf /var/lib/apt/lists/*



#install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC \
        && git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify \
        && rm -rf /opt/noVNC/.git \
        && rm -rf /opt/noVNC/utils/websockify/.git 

#RUN echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/Debian_10/ /' | sudo tee /etc/apt/sources.list.d/home:stevenpusser.list && \
#    curl -fsSL https://download.opensuse.org/repositories/home:stevenpusser/Debian_10/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stevenpusser.gpg > /dev/null

# install lightweight browser - Palemoon
# RUN apt-get update && apt-get -y install palemoon
# RUN apt-get -y install spotify-client
# RUN wget -q -P /tmp  https://download.anydesk.com/linux/deb/anydesk_6.0.1-1_amd64.deb
# RUN wget -q -P /tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \ not working anymore
RUN wget -q -P /tmp https://gpopesc.i234.me/old_root/wps/wps-office_11.1.0.11711.XA_amd64 && \
    wget -q -P /tmp https://gpopesc.i234.me/old_root/wps/icefact_1.8.2-1_amd64.deb
RUN apt-get install -y /tmp/*.deb
RUN rm -f /tmp/*.deb



EXPOSE 5900 8000

WORKDIR /root/

HEALTHCHECK --interval=1m --timeout=10s CMD curl --fail http://127.0.0.1:8000/vnc.html

# Cron job
RUN touch /tmp/cron.log && (crontab -l; echo "5 5 * * * apt update && sleep 10 && script -c 'apt upgrade -y' /tmp/cron.log  && sleep 10 && apt autoclean") | crontab

#config files to temp location
RUN mkdir /opt/.vnc && mkdir /tmp/config
COPY ./config/* /tmp/config/
COPY startup.sh /
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]
