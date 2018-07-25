# Remote Control Keybinds for Pseudo Channel and Rasplex
Set of scripts and openbox binds to operate this remote (https://amzn.to/2LE6nc4) with Pseudo Channel and RasPlex. In addition to Pseudo Channel and Rasplex, the scripts also assume the existence of various sound files in /home/pi/sounds. These can be any desired sounds in compatible format for button press, depress and reboot.

If using a Raspberry Pi under username pi, simply clone this repository into /home/pi/remote/ and append the contents of APPEND-TO-lxde-pi-rc.xml to the openbox xml. Again, if using a Raspberry Pi under the username pi, this file can be found in /home/pi/.config/openbox/lxde-pi-rc.xml.

Edit the variables in remote-functions.sh to match your settings

Set up an rsa token from this device to the Rasplex device. (instructions https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)

After this, a simple restart of openbox `openbox --restart` or rebooting of the device will enable the binds. 
