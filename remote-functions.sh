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
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(REBOOTING\ ALL\ DEVICES,Please\ Stand\ By,20000\)"
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
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(SHUT\ DOWN,Please\ Stand\ By,20000\)"
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
ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(CHANNEL\ UP,Executing...,20000\)"
}

channel_down () {
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
		ssh -i "$rsa" "$controller_user"@"$controller_ip" -t "cd $ps && sudo nohup ./channeldown.sh"
	else
		cd "$ps" && sudo ./channeldown.sh
fi
ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(CHANNEL\ DOWN,Executing...,20000\)"
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
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,BACK,5000\)"
}

rasplex_fullscreen () {
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,FULLSCREEN,5000\)"
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "FullScreen"
}

rasplex_up () {
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,UP,5000\)"
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Up"
}

rasplex_down () {
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,DOWN,5000\)"
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Down"
}

rasplex_left () {
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,LEFT,5000\)"
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Left"
}

rasplex_right () {
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,RIGHT,5000\)"
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Right"
}

rasplex_select () {
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,SELECT,5000\)"
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
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,CLOSE\ DIALOGUE,5000\)"
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Close"
}

rasplex_audio_language () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "AudioNextLanguage"
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,Audio\ Language,5000\)"
}

rasplex_next_subtitle () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "NextSubtitle"
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,SUBTITLE\ NEXT,5000\)"
}

rasplex_showsubtitles () {
        ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "ShowSubtitles"
	ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(Button\ Press,TOGGLE SUBTITLES,5000\)"
}

stop_all_channels () {
ssh -i "$rsa" "$client_user"@"$client_ip" xbmc-send --host=127.0.0.1 -a "Notification\(STOPPING\ PSEUDO\ CHANNEL,Please\ Stand\ By...,5000\)"
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
		ssh -i "$rsa" "$controller_user"@"$controller_ip" -t "cd $ps && sudo nohup ./stop-all-channels.sh"
	else
	cd "$ps" && sudo ./stop-all-channels.sh
fi
}
