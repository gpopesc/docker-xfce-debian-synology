# Full installation in docker of a debian container with Xfce desktop

It includes Chromium, Firefox, Palemoon, Xarchiver, Putty, Onboard virtual keyboard, Picture viewer, Mousepad text editor and many addons from XFCE desktop.
It has built in vnc server and noVNC for web access.

There is a minimal docker container, only with basics, and you can install it from here: https://hub.docker.com/r/gpopesc/xfce-debian-synology 

Modify the password and the screen resolution in docker-compose. The default password is admin.
Map your ports as you wish. Default port for vnc connection 5905 and for http port 8087.
SHM added in order to avoid errors on Firefox when running.
The image was tested on Synology DS218+ .

Wait for container to startup about 1 minute, depending of your configuration.
Acces the container with a VNC client on port 5905 or simply http://server-ip:8087 in your browser.

Use reverse proxy if you want to secure your connection. Create websocket on your reverse proxy settings in Synology.
![image](https://user-images.githubusercontent.com/11590919/124982716-b4741500-e03f-11eb-968d-99a0c4ae46f7.png)




# Installation: 

*Method 1: Easyest with docker-compose.yml :*

```
version: "3"
services:
  synodebian:
    image: gpopesc/xfce-debian-synology-full
    container_name: syno-debian
    environment:
      - VNCPASS=admin
      - DISPLAY_WIDTH=1200
      - DISPLAY_HEIGHT=720
      - TZ=Europe/Bucharest
    ports:
      - 5905:5900   #vnc port
      - 8087:8080   #http port
    volumes:
      - ./data:/root/Downloads
      - type: tmpfs
        target: /dev/shm
        tmpfs:
         size: 4000000000 # ~4gb
    restart: unless-stopped
```
Create a local folder "data", then "docker-compose up -d" from your SSH command prompt.


*Method 2: install from docker CLI*
From your SSH client copy-paste and run following command:

```
docker run -p 8087:8080 -p 5905:5900\
 -e VNCPASS=admin\
 -e DISPLAY_WIDTH=1200\
 -e DISPLAY_HEIGHT=720\
 -e TZ=Europe/Bucharest\
 -v /volume1/docker/syno-debian/data:/root/Downloads\
 --shm-size 4g\
 --name syno-debian\
 --restart unless-stopped\
 gpopesc/xfce-debian-synology-full
```
Create local folder "data" and map it in the command. Adjust full local path acordingly: "/volume1/docker/syno-debian/data"
Replace default password and resolution with desired option.

![image](https://user-images.githubusercontent.com/11590919/124983614-db7f1680-e040-11eb-8c00-8366fa22bfea.png)

 

