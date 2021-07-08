# Minimal installation in docker of a debian container with Xfce desktop

It use about 500Mb disk size and it needs about 350-400Mb RAM.
It has built in vnc server and noVNC for web access.

Modify the password and the screen resolution in docker-compose. The default password is admin.
Map your ports as you wish. Default port for vnc connection 5905 and for http port 8080.
The image was tested on Synology DS218+

Use reverse proxy if you want to secure your connection. Create websocket on your reverse proxy settings in Synology.
![image](https://user-images.githubusercontent.com/11590919/124982716-b4741500-e03f-11eb-968d-99a0c4ae46f7.png)


You can build the image yourself with the apps you need or you download the minimal installation from docker hub.

# Installation: 

*Method 1: Easyest with docker-compose.yml :*

```
version: "3"
services:
  synodebian:
    image: gpopesc/docker-xfce-debian-synology
    container_name: syno-debian
    environment:
      - VNCPASS=admin
      - DISPLAY_WIDTH=1200
      - DISPLAY_HEIGHT=720
    ports:
      - 5905:5900   #vnc port
      - 8080:8080   #http port
    volumes:
      - ./data:/root/Downloads
      - /etc/localtime:/etc/localtime:ro
      - type: tmpfs
        target: /dev/shm
        tmpfs:
         size: 4000000000 # ~4gb
    restart: unless-stopped
```
Create a local folder "data", then "docker-compose up -d" from your ssh command prompt
Wait for container to startup about 1 minute, depending of your configuration.
Acces the container with a VNC client on port 5905 or simply http://server-ip:8080 in your browser.
SHM added in order to avoid errors on Firefox when running.


*Method 2: build the image yourself and customize it according with your needs.*

 - git https://github.com/gpopesc/docker-xfce-debian-synology.git
 - cd docker-xfce-debian-synology
 - docker-compose build --pull
 - docker-compose up -d


Dockerfile has a lot optional apps which are not installed by default.
Uncomment the corespondent lines if you want to install them.



*Method 3: install from docker CLI*
From your ssh client run following command:

'''
docker run -p 8080:8080 -p 5905:5900 \
-v ./data:/root/Downloads \
-v /etc/localtime:/etc/localtime:ro \
-e VNCPASS=admin \
-e DISPLAY_WIDTH=1200 \
-e DISPLAY_HEIGHT=720 \
--name syno-debian --restart unless-stopped\
gpopesc/docker-xfce-debian-synology
'''
Create local folder data and map it in the command.
Replace default password and resolution with desired option.

![image](https://user-images.githubusercontent.com/11590919/124983614-db7f1680-e040-11eb-8c00-8366fa22bfea.png)

 

