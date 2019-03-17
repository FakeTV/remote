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
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "REBOOTING ALL DEVICES", "message": "Please Stand By", "displaytime": 20000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
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
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "SHUTTING DOWN", "message": "Please Stand By", "displaytime": 20000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
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
curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "CHANNEL UP", "message": "Executing...", "displaytime": 20000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

channel_down () {
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
		ssh -i "$rsa" "$controller_user"@"$controller_ip" -t "cd $ps && sudo nohup ./channeldown.sh"
	else
		cd "$ps" && sudo ./channeldown.sh
fi
curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "CHANNEL DOWN", "message": "Executing...", "displaytime": 20000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

channel () {
        curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "'"${channel_number}"'", "message": "Starting Channel '"$channel_number"'", "displaytime": 15000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
		ssh -i "$rsa" "$controller_user"@"$controller_ip" -t "cd $ps && sudo nohup ./manual.sh $channel_number"
	else
	cd "$ps" && sudo ./manual.sh "$channel_number"
fi
}

rasplex_back () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "BACK", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
	curl -d '{"jsonrpc": "2.0", "method": "Input.Back", "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_fullscreen () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "FULLSCREEN", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
	curl -d '{"jsonrpc": "2.0", "method": "GUI.SetFullscreen", "params": { "fullscreen": "toggle"}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_up () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "UP", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
	curl -d '{"jsonrpc": "2.0", "method": "Input.Up", "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_down () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "DOWN", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
        curl -d '{"jsonrpc": "2.0", "method": "Input.Down", "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_left () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "LEFT", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
        curl -d '{"jsonrpc": "2.0", "method": "Input.Left", "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_right () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "RIGHT", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
        curl -d '{"jsonrpc": "2.0", "method": "Input.Right", "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_select () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "SELECT", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
        curl -d '{"jsonrpc": "2.0", "method": "Input.Select", "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_volumeup () {
        curl -d '{"jsonrpc": "2.0", "method": "Application.SetVolume", "params": { "volume": "increment"}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_volumedown () {
	curl -d '{"jsonrpc": "2.0", "method": "Application.SetVolume", "params": { "volume": "decrement"}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_mute () {
        curl -d '{"jsonrpc": "2.0", "method": "Application.SetMute", "params": { "mute": "toggle"}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_show_info () {
        curl -d '{"jsonrpc": "2.0", "method": "Input.Info", "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_detail_info () {
        curl -d '{"jsonrpc": "2.0", "method": "Input.ShowCodec", "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_screenshot () {
        curl -d '{"jsonrpc": "2.0", "method": "Input.ExecuteAction", "params": { "action": "screenshot"}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
        curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Saved Screenshot", "message": " ", "displaytime": 1500}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_close_dialogue () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "CLOSE DIALOGUE", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
	curl -d '{"jsonrpc": "2.0", "method": "Input.Home", "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_audio_language () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "AUDIO LANGUAGE", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
	curl -d '{"jsonrpc": "2.0", "method": "Player.SetAudioStream", "params": { "playerid": 1, "stream": "next"}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_next_subtitle () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "SUBTITLE NEXT", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
	curl -d '{"jsonrpc": "2.0", "method": "Input.ExecuteAction", "params": { "action": "cyclesubtitle"}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

rasplex_showsubtitles () {
	curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "Button Press", "message": "TOGGLE SUBTITLES", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
	curl -d '{"jsonrpc": "2.0", "method": "Input.ExecuteAction", "params": { "action": "showsubtitles"}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
}

stop_all_channels () {
curl -d '{"jsonrpc": "2.0", "method": "GUI.ShowNotification", "params": { "title": "STOPPING PSEUDO CHANNEL", "message": "Please Stand By...", "displaytime": 5000}, "id": 1}' -H "Content-Type: application/json" -X POST http://$client_ip:3005/jsonrpc
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
		ssh -i "$rsa" "$controller_user"@"$controller_ip" -t "cd $ps && sudo nohup ./stop-all-channels.sh"
	else
	cd "$ps" && sudo ./stop-all-channels.sh
fi
}
