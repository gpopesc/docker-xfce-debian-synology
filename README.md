# Minimal installation in docker of a debian container with Xfce desktop

It use about 500Mb disk size and it needs about 350-450Mb RAM when running (more with firefox or chromium).
It has built in vnc server and noVNC for web access.

There is a full docker image with all apps preinstalled here: https://hub.docker.com/r/gpopesc/xfce-debian-synology-full 
It has Chromium, Firefox, Palemoon, Putty, Image viewer, Mousepad text editor, Xarchiver and many plugins from XFCE desktop

Modify the password and the screen resolution in docker-compose. The default password is admin.
Map your ports as you wish. Default port for vnc connection is 5905 and for http port is 8087.
SHM added in docker compose or CLI in order to avoid errors on Firefox when running.
The image was tested on Synology DS218+ .

Acces the container with a VNC client on port 5905 or simply http://server-ip:8087 in your browser.
Wait for container to startup about 1 minute, depending of your configuration.
Execute the script from Home folder: capslock_toggle.sh if the caps lock remain on or install a virtual keyboard ``` apt-get update && apt-get install onboard ```

You can add a browser inside from terminal, after succesfull container deployment:
```
apt-get update && apt-get install palemoon
or
apt-get update && apt-get install firefox-esr
```

Use reverse proxy if you want to secure your connection. Create websocket on your reverse proxy settings in Synology.
![image](https://user-images.githubusercontent.com/11590919/124982716-b4741500-e03f-11eb-968d-99a0c4ae46f7.png)


You can build the image yourself with the apps you need or you download the minimal installation from docker hub.

# Installation: 

*Method 1: Easyest with docker-compose.yml :*

```
version: "3"
services:
  synodebian:
    image: gpopesc/xfce-debian-synology
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
Create a local folder "data", then "docker-compose up -d" from your ssh command prompt


*Method 2: build the image yourself and customize it according with your needs.*

```
 git clone https://github.com/gpopesc/xfce-debian-synology.git
 cd xfce-debian-synology
 docker-compose build --pull
 docker-compose up -d
 ```


Dockerfile has a lot optional apps, which are not installed by default.
Uncomment the corespondend lines if you want to install them.



*Method 3: install from docker CLI*
From your SSH client copy-paste and run following command (all rows, one time):

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
 gpopesc/xfce-debian-synology
```
Create local folder "syno-debian/data" in your docker folder and map it in the command. Adjust full local path acordingly: "/volume1/docker/syno-debian/data"
Replace default password and resolution with desired options.

![image](https://user-images.githubusercontent.com/11590919/124983614-db7f1680-e040-11eb-8c00-8366fa22bfea.png)

 

