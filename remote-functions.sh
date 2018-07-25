#!/bin/bash

function_id=$1
channel_number=$2
client_ip="PLEX_CLIENT_IP_ADDRESS"
server_ip="PLEX_SERVER_IP_ADDRESS"
netcontroller_ip="NETWORK_CONTROLLER_IP_ADDRESS"
client_user="PLEX_CLIENT_USERNAME"
server_user="PLEX_SERVER_USERNAME"
netcontroller_user="NETWORK_CONTROLLER_USERNAME"
rsa="/home/pi/.ssh/id_rsa" #location of rsa token
ps="/home/pi/channels/" #location of Pseudo Channel

button_press () {
	aplay -q /home/pi/sounds/button-down.wav &
}

button_depress () {
	aplay -q /home/pi/sounds/button-up.wav &
}

reboot () {
	cd /home/pi
	chromium-browser localhost/standby.jpg
	aplay -q /home/pi/sounds/runaway.wav &
	cd "$ps"
	sudo ./stop-all-channels.sh
	ssh -i "$rsa" "$server_user"@"$server_ip" sudo reboot now
	ssh -i "$rsa" "$netcontroller_user"@"$netcontroller_ip" sudo reboot now
	ssh -i "$rsa" "$client_user"@"$client_ip" reboot now
	sudo reboot now
	while [ true ]; do aplay /home/pi/sounds/button-down.wav; done;
}

shutdown () {
	cd /home/pi
	chromium-browser localhost/standby.jpg
	aplay -q /home/pi/sounds/shutdown.wav &
	cd "$ps"
	sudo ./stop-all-channels.sh
	ssh -i "$rsa" "$server_user"@"$server_ip" sudo shutdown now
	ssh -i "$rsa" "$netcontroller_user"@"$netcontroller_ip" sudo shutdown now
	ssh -i "$rsa" "$client_user"@"$client_ip" shutdown now
}

reset_status_screen () {
	sudo service lightdm restart
}

channel_up () {
	cd "$ps" && sudo ./channelup.sh
}

channel_down () {
	cd "$ps" && sudo ./channeldown.sh
}

channel () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\($channel_number,Starting\ Channel\ $channel_number,20000\)"
	cd "$ps" && sudo ./manual.sh "$channel_number"
}

lead_number () {
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\($channel_number\ -,Waiting\ for\ keypress,3000\)"
}

rasplex_back () {
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Back"
}

rasplex_fullscreen () {
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "FullScreen"
}

rasplex_up () {
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Up"
}

rasplex_down () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Down"
}

rasplex_left () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Left"
}

rasplex_right () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Right"
}

rasplex_select () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Select"
}

rasplex_volup () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "VolumeUp"
}

rasplex_voldown () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "VolumeDown"
}

rasplex_mute () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Mute"
}

rasplex_info () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Info"
}

rasplex_codec () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "CodecInfo"
}

rasplex_screenshot () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Screenshot"
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Saved\ Screenshot,\ ,1000\)"
}

rasplex_close_dialogue () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Close"
}

rasplex_audio_language () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "AudioNextLanguage"
}

rasplex_nextsub () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "NextSubtitle"
}

rasplex_showsubs () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "ShowSubtitles"
}

stopall () {
	cd "$ps" && sudo ./stop-all-channels.sh
}
