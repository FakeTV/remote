#!/bin/bash
source remote_token.sh
function_id=$1
channel_number=$2


button_press_sound () {
	aplay -q "$button_down" &
}

button_depress_sound () {
	aplay -q "$button_up" &
}

reboot_all () {
	stop_all_channels
	ssh -i "$rsa" "$server_user""@""$server_ip" sudo reboot now
	ssh -i "$rsa" "$client_user""@""$client_ip" reboot now
	if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
		then
			ssh -i "$rsa" "$controller_user""@""$controller_ip" -t "sudo reboot now"
	fi
	sudo reboot now
	while [ true ]; do button_press_sound; done;
}

shutdown_all () {
	stop_all_channels
	ssh -i "$rsa" "$server_user"@"$server_ip" sudo shutdown now
	ssh -i "$rsa" "$client_user"@"$client_ip" shutdown now
	if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
		then
			ssh -i "$rsa" "$controller_user"@"$controller_ip" -t "sudo shutdown now"
	fi
}

reset_status_screen () {
	sudo service lightdm restart
}

channel_up () {
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
		ssh -i "$rsa" "$controller_user"@"$controller_ip" -t "cd $ps && sudo nohup ./channelup.sh"
	else
		"$ps" && sudo ./channelup.sh
fi
}

channel_down () {
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
		ssh -i "$rsa" "$controller_user"@"$controller_ip" -t "cd $ps && sudo nohup ./channeldown.sh"
	else
		cd "$ps" && sudo ./channeldown.sh
fi
}

channel () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\($channel_number,Starting\ Channel\ $channel_number,20000\)"
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
		ssh -i "$rsa" "$controller_user"@"$controller_ip" -t "cd $ps && sudo nohup ./manual.sh $channel_number"
	else
	cd "$ps" && sudo ./manual.sh "$channel_number"
fi
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

rasplex_volumeup () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "VolumeUp"
}

rasplex_volumedown () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "VolumeDown"
}

rasplex_mute () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Mute"
}

rasplex_show_info () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Info"
}

rasplex_detail_info () {
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

rasplex_next_subtitle () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "NextSubtitle"
}

rasplex_showsubtitles () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "ShowSubtitles"
}

stop_all_channels () {
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
		ssh -i "$rsa" "$controller_user"@"$controller_ip" -t "cd $ps && sudo nohup ./stop-all-channels.sh"
	else
	cd "$ps" && sudo ./stop-all-channels.sh
fi
}
