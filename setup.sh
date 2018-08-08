#!/bin/bash

sudo chmod 777 ./*
sudo sed -i $'/<\/keyboard>/{e cat APPEND-TO-lxde-pi-rc.xml\n}' /home/pi/.config/openbox/lxde-pi-rc.xml

exit 0
