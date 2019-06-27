
#!/bin/bash
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
echo "INSTALLING DEPENDENCIES..."
sudo apt-get -y install python python-pip git libxml2-utils
echo "DEPENDENCIES INSTALLED!"
sleep 1
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
#sudo chmod 777 ./*
echo "Gathering PRELIMINARY INFORMATION"
echo "SELECT the LOCAL USER ACCOUNT that THIS SCRIPT and PSEUDO CHANNEL are installed under."
allusers=$(ls /home)
select home_user in $allusers
	do
	homedir="/home/$home_user/"
	break
done
echo "The HOME DIRECTORY is $homedir"
sleep 1
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
ps="$homedir""channels"
if [ ! -d "$ps" ]
	then
	echo "PSEUDO CHANNEL not found on local device."
	echo "Is PSEUDO CHANNEL installed on a REMOTE DEVICE?"
	read -p "Y/N: " is_ps_remote_device
	while [[ "$is_ps_remote_device" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
		do
		echo "Is PSEUDO CHANNEL installed on a REMOTE DEVICE?"
		read -p "Y/N: " is_ps_remote_device
	done
	if [[ "$is_ps_remote_device" == @(N|n|No|no|NO) ]]
		then
		echo "Please INSTALL PSEUDO CHANNEL before CONTINUING"
		exit
	fi
	else
	source $ps/config.cache
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "PLEX SERVER is $server_ip:$server_port"
	echo "PLEX AUTH TOKEN is $server_token"
	echo "Enter the SSH LOGIN USERNAME for the PLEX SERVER device"
	read -p 'Plex Server Device SSH Login: ' server_user
fi
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "GETTING PSEUDO CHANNEL INFORMATION"
	echo "Enter the PSEUDO CHANNEL device IP ADDRESS"
	read -p 'Pseudo Channel Device IP: ' controller_ip
	echo "Enter the SSH LOGIN USERNAME for the PSEUDO CHANNEL device"
	read -p 'Pseudo Channel Device SSH Login: ' controller_user
	echo "Enter the PSEUDO CHANNEL DIRECTORY PATH on the PSEUDO CHANNEL device (example: /home/pi/channels_Clientname)"
	read -p 'Pseudo Channel Directory Path: ' ps
	echo "PSEUDO CHANNEL is in $ps on $controller_ip"
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "GETTING PLEX SERVER INFORMATION"
	echo "Enter the PLEX SERVER IP ADDRESS"
	read -p 'Plex Server IP Address: ' server_ip
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "Enter the PLEX SERVER PORT NUMBER"
	read -p 'Plex Server Port (default 32400): ' server_port
	if [ "$server_port" == '' ]
		then
		server_port='32400'
	fi
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "ENTER your PLEX AUTHENTICATION TOKEN"
	echo "(for help finding token, check here: https://bit.ly/2p7RtOu)"
	read -p 'Plex Auth Token: ' server_token
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "Enter the SSH LOGIN USERNAME for the PLEX SERVER device"
	read -p 'Plex Server Device SSH Login: ' server_user
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "PLEX SERVER is $server_ip:$server_port"
	echo "PLEX AUTH TOKEN is $server_token"
fi
sleep 1
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
echo "GETTING PLEX CLIENT INFORMATION"
echo "SELECT the IP ADDRESS of the PLEX CLIENT from the LIST BELOW"
echo "or ENTER one NOT LISTED"
clienthosts=$(xmllint --xpath "//Server/@host" "http://$server_ip:$server_port/clients/?X-Plex-Token=$server_token" | sed "s|host=||g" | sed "s|^ ||g" && echo -e " Other")
eval set $clienthosts
select client_ip in "$@"
	do
        if [[ "$client_ip" == "Other" ]]
	        then
                read -p 'Client IP: ' client_ip
                client_ip=$(eval echo $client_ip)
        fi
break
done
sleep 1
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
echo "Enter the SSH LOGIN USERNAME for the PLEX CLIENT device at $client_ip"
read -p 'Plex Client SSH Login: ' client_user
echo "The PLEX CLIENT is $client_user@$client_ip"
sleep 1
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
echo "SETTING UP SSH KEYS BETWEEN DEVICES"
echo "GENERATING KEY..."
ssh-keygen -t rsa
echo "If not using the DEFAULT location ($homedir.ssh/id_sra)"
echo "ENTER the KEY LOCATION (press ENTER for DEFAULT)"
read -p "RSA Token (default: $homedir.ssh/id_rsa): " rsa
if [[ $rsa == '' ]]
        then
                rsa="$homedir.ssh/id_rsa"
fi
sleep 1
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
echo "SETTING UP SSH KEYS BETWEEN DEVICES"
echo "COPYING KEY in $rsa TO PLEX CLIENT AT $client_user@$client_ip"
ssh-copy-id "$client_user@$client_ip"
sleep 1
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
echo "SETTING UP SSH KEYS BETWEEN DEVICES"
echo "COPYING KEY in $rsa TO PLEX SERVER AT $server_user@$server_ip"
ssh-copy-id "$server_user@$server_ip"
sleep 1
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
echo "SETTING UP SSH KEYS BETWEEN DEVICES"
if [[ "$is_ps_remote_device" == @(Y|y|yes|Yes|YES) ]]
        then
	echo "COPYING KEY in $RSA TO PSEUDO CHANNEL DEVICE AT $controller_user@$controller_ip"
	ssh-copy-id "$controller_user@$controller_ip"
	else
	echo "KEY SETUP COMPLETE"
fi
sleep 1
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
echo "SETTING UP KEYBINDS"
echo "CONTINUE with BINDING remote keys to PSEUDO CHANNEL and RASPLEX actions?"
read -p "Y/N: " do_remote_bindings
while [[ "$do_remote_bindings" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
	do
		echo "CONTINUE with BINDING remote keys to ACTIONS"
		read -p "Y/N: " do_remote_bindings
	done
if [[ "$do_remote_bindings" == @(Y|y|Yes|yes|YES) ]]
then
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "SETTING UP KEYBINDS"
	today=$(date)
	echo "<!-- Start of Remote Control Binds set $today -->" | tee temp.xml >/dev/null
	echo "Play SOUND FILE with KEY PRESS and KEY RELEASE"
	read -p "Y/N: " soundfile
	while [[ "$soundfile" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
		do
			echo "Play SOUND FILE with KEY PRESS and KEY RELEASE"
			read -p "Y/N: " soundfile
	done
	if [[ "$soundfile" == @("Y"|"y"|"yes"|"Yes"|"YES") ]]
		then
		sound="yes"
		echo "Enter location of KEY PRESS sound"
		echo "(EXAMPLE: /home/pi/sounds/keypress.wav)"
		read -p '' button_down
		echo "Enter location of KEY DEPRESS sound"
		echo "(EXAMPLE: /home/pi/sounds/keydepress.wav)"
		read -p '' button_up
		echo "Button press sound is $button_down"
		echo "Button depress sound is $button_up"
	else
		sound="no"
		button_down=''
		button_up=''
		echo "BUTTON SOUNDS have been DISABLED"
	fi
	if [ "$sound" == "yes" ]
		then
			sh_template="keybind-script-template-with-sound.sh"
			channel_template="channel-template-with-sound.sh"
		else
			sh_template="keybind-script-template-no-sound.sh"
			channel_template="channel-template-no-sound.sh"
	fi
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "SETTING UP KEYBINDS"
	echo "Enable NUMBER BUTTONS (0-9) to activate CHANNELS?"
	read -p "Y/N: " number_buttons
	while [[ "$number_buttons" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
		do
			echo "Enable NUMBER BUTTONS (0-9) to activate CHANNELS?"
			read -p "Y/N: " number_buttons
		done
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "SETTING UP KEYBINDS"
	if [[ "$number_buttons" == @(Y|y|Yes|yes|YES) ]]
		then
			if [[ "$is_ps_remote_device" == @(Y|y|Yes|yes|YES) ]]
				then
				number_of_channels=$(ssh -i "$rsa" "$controller_user""@""$controller_ip" -t ls $ps | grep pseudo-channel_ | wc -l)
				else
				number_of_channels=$(ls $ps | grep pseudo-channel_ | wc -l)
			fi
			echo "$number_of_channels CHANNELS DETECTED"
			if [ "$number_of_channels" -gt 99 ]
				then
					echo "Too many CHANNELS"
					echo "Setting NUMBER OF CHANNELS to 99"
					number_of_channels=99
			fi
			channel_position=1
			leadkey=0
			sleep 1
			clear
			echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
			echo "Setting up KEYBINDS for $number_of_channels CHANNELS"
			echo "  <keybind key=\"$leadkey\">" | tee -a "$homedir""remote/temp.xml" >/dev/null
			while [ $channel_position -le $number_of_channels ]
				do
					key=${channel_position: -1}
					if [ "$key" -eq "0" ]
						then
							leadkey=$(($leadkey+1))
							eval "echo \"  </keybind>\"" | tee -a "$homedir""remote/temp.xml" >/dev/null
							echo "  <keybind key=\"$leadkey\">" | tee -a "$homedir""remote/temp.xml" >/dev/null
					fi
					channel_number="$leadkey""$key"
					script="$homedir""remote/""$channel_number"".sh"
					eval "echo \"$(cat $channel_template)\"" | tee "$script" >/dev/null
					eval "echo \"$(cat keybind-template.xml)\"" | tee -a "$homedir""remote/temp.xml" >/dev/null
					channel_position=$(($channel_position+1))
					echo "CHANNEL $channel_number of $number_of_channels keybind set."
				done
			eval "echo \"  </keybind>\"" | tee -a "$homedir""remote/temp.xml" >/dev/null
			echo "CHANNEL bindings complete. Starting KEY bindings..."
	fi
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "BIND ADDITIONAL KEYS?"
	read -p "Y/N: " bind_remote
	while [[ "$bind_remote" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
		do
			echo "BIND ADDITIONAL KEYS?"
			read -p "Y/N: " bind_remote
		done
	while [[ "$bind_remote" == @(Y|y|yes|Yes|YES) ]]
		do
			sleep 1
			clear
			echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
			echo "BINDING KEYS"
			xhost +
			export DISPLAY=:0
			echo "Choose the ACTION to BIND to a KEY"
			"./list.sh"
			command_list=$(cat command_list)
			select script_action in $command_list
				do
				echo "PRESS the BUTTON on the REMOTE to bind to $script_action"
				key=$(xev -event keyboard | awk -W interactive -F'[ )]+' '/^KeyRelease/ { a[NR+2] } NR in a { printf "%s\n", $8;exit;}')
				echo "BINDING $script_action to the $key BUTTON"
				script="$homedir""remote/""$script_action"".sh"
				eval "echo \"$(cat $sh_template)\"" | tee "$script" >/dev/null
				eval "echo \"$(cat keybind-template.xml)\"" | tee -a "$homedir""remote/temp.xml" >/dev/null
				break
			done
			echo "BIND another KEY?"
			read -p 'Y/N: ' bind_remote
			while [[ "$bind_remote" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
				do
					echo "BIND another KEY?"
					read -p 'Y/N: ' bind_remote
				done
		done
	echo "<!-- End of Remote Control Binds set $today -->" | tee -a temp.xml >/dev/null
	eval "echo \"$(cat remote_token_template.sh)\"" | tee remote_token.sh >/dev/null
	sleep 1
	clear
	echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
	echo "SELECT the OPENBOX keybind XML file from the LIST"
	openbox_directory_contents=$(ls "$homedir".config/openbox/)
	select openbox_xml in "$openbox_directory_contents"
		do
			echo "APPENDING $homedir.config/openbox/$openbox_xml with new KEYBINDS."
			break
		done
	cp "$homedir".config/openbox/"$openbox_xml" "$homedir"backup-"$openbox_xml"
	sed -i $'/<\/keyboard>/{e cat temp.xml\n}' "$homedir".config/openbox/"$openbox_xml"
fi
sleep 1
clear
echo "++++++++++++++++++++REMOTE CONTROL KEYBIND SETUP++++++++++++++++++++"
echo "COMPLETING KEYBIND SETUP AND PREPARING TO EXIT..."
find . -type f -name "*.sh" -exec chmod +x {} \;
sudo service lightdm restart
sleep 1
exit 0
