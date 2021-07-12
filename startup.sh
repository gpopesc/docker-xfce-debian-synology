#!/bin/bash
#add steven repository, enable autoupdate for palemoon
echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/Debian_10/ /' | tee /etc/apt/sources.list.d/home:stevenpusser.list 
curl -fsSL https://download.opensuse.org/repositories/home:stevenpusser/Debian_10/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_stevenpusser.gpg > /dev/null



