#Minimal installation in docker for debian container with Xfce desktop

It use about 500Mb disk size and it needs about 350-400Mb RAM.
It has built in vnc and noVNC for web access.

Modify the password and the screen resolution in docker-compose
Map your ports as you wish.
The image was tested on Synology DS218+

Use reverse proxy if you want to secure your connection.

You can build the image yourself with the apps you need or you download the minimal installation from docker hub.

# Installation: 
 - git
 - cd 
 - docker-compose build --pull
 - docker-compose up -d
 - acces the image with a VNC client or simply http://server-ip:8080

#Optionals
The Dockerfile has a lot optional apps which are not installed by default.
Uncomment the corespondent lines if you want to install them.

```
 # Screenshot
 XFCE desktop in an Xnest window running with x11docker:
 
 ![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-xfce.png "XFCE desktop running in Xephyr window using x11docker")
 

