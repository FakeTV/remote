#!/bin/bash

set_home_dir () {
sudo chmod 777 ./*
printf "\nBeep Boop! Welcome to the Remote Keybind and Pseudo Channel Setup script.\n" | fold -s
printf "\nThis script will install dependencies and Pseudo Channel (if not already installed) and gather necessary information before setting up keybinds.\n" | fold -s
printf "\nHold tight, here we go!\n" | fold -s
printf "\nEnter the name of the local user account\n" | fold -s
allusers=$(ls /home)
select home_user in $allusers
	do
		homedir="/home/$home_user/"
		break
	done
printf "\nHome directory is $homedir\n" | fold -s
}

install_dependencies () {
printf "\nNow installing prerequisite dependencies.\n" | fold -s
#printf "\nInstalling python...\n" | fold -s
sudo apt-get -y install python python-pip git libxml2-utils figlet
#printf "\nInstalling python-pip...\n" | fold -s
#sudo apt-get -y install python-pip
#printf "\nInstalling git...\n" | fold -s
#sudo apt-get -y install git
#printf "\nInstalling libxml2-utils...\n" | fold -s
#sudo apt-get -y install libxml2-utils
printf "\nDependencies installed, moving on to bigger and better things...\n" | fold -s
}

get_ps_config () {
if [[ "$is_ps_remote_device" == @("N"|"n"|"No"|"no"|"NO") ]]
	then
		printf "\nEnter the name of the desired Plex Client.\n" | fold -s
		printf "\nIf you intend to use the multibox setup, enter the main client name here.\n" | fold -s
		printf "\nBelow is is a list of available clients according to your Plex server.\n" | fold -s
		printf "\nOther clients may function, but those listed will work with more certainty.\n" | fold -s
		clientlist=$(xmllint --xpath "//Server/@name" "http://$server_ip:$server_port/clients")
		echo $clientlist | sed "s| \"|\n\"|g"
		read -p 'Desired Client Name (Including quotation marks): ' ps_client_entry
		ps_client="[""$ps_client_entry""]"
		printf "\n\nEnter the names of your Plex TV Show libraries.\n" | fold -s
		printf "\nInclude quotation marks around each library name and separate each entry with a comma (example below)\n" |fold -s
		printf "\nExample: \"TV Shows\",\"Cartoons\",\"Other Shows\"\n" | fold -s
		read -p 'TV Show Libraries: ' ps_tv_entry
		ps_tv="[""$ps_tv_entry""]"
		printf "\n\nEnter the names of your Plex Movie libraries using the same format as above\n" | fold -s
		read -p 'Movie Libraries: ' ps_movie_entry
		ps_movie="[""$ps_movie_entry""]"
		printf "\n\nWould you like to use commercial injection in between scheduled items in Pseudo Channel?\n" | fold -s
		read -p 'Y/N: ' commercial_injection
		while [[ "$commercial_injection" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
			do
				printf "\nBeep Boop! Entry not valid\n" | fold -s
				printf "\n\nWould you like to use commercial injection in between scheduled items in Pseudo Channel?\n" | fold -s
				read -p 'Y/N: ' commercial_injection
			done

		if [[ "$commercial_injection" == @("Y"|"y"|"yes"|"Yes"|"YES") ]]
			then
				commercials_true=true
				printf "\nEnter the names of your Plex Commercials libraries using the same format as above\n"
				read -p 'Commercial Libraries: ' ps_commercials_entry
				ps_commercials="[""$ps_commercials_entry""]"
			else
				commercials_true=false
			fi
		printf "\nAt what time would you like the daily schedule to reset for the next day?\n" | fold -s
		read -p 'Time (24h clock format): ' reset_time
	fi
}

remote_bind_start () { #Bind keypresses to various common actions
printf "\nDo you wish to bind commands to a remote control plugged into this device?\n" | fold -s
read -p "Y/N: " do_remote_bindings
while [[ "$do_remote_bindings" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
	do
		printf "\nBeep Boop! Entry not valid\n" | fold -s
		printf "\nDo you wish to bind commands to a remote control plugged into this device?\n" | fold -s
		read -p "Y/N: " do_remote_bindings
	done
if [[ "$do_remote_bindings" == @(Y|y|Yes|yes|YES) ]]
then
	today=$(date)
	echo "<!-- Start of Remote Control Binds set $today -->" | sudo tee temp.xml
	printf "\nThe remote keybinding tool will bind keypresses on your remote to scripts for use with Pseudo Channel and RasPlex.\n" | fold -s
	printf "\nDo you have sound files to play with key press and release?\n" | fold -s
	read -p "Y/N: " soundfile
	while [[ "$soundfile" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
		do
			printf "\nBeep Boop! Entry not valid\n" | fold -s
			printf "\nDo you have sound files to play with key press and release?\n" | fold -s
			read -p "Y/N: " soundfile
		done
	if [[ "$soundfile" == @("Y"|"y"|"yes"|"Yes"|"YES") ]]
		then
		sound="yes"
		printf "\nEnter the location of the key press sound (example: /home/pi/sounds/keypress.wav):" | fold -s
		read -p '' button_down
		printf "\nEnter the location of the key depress sound:" | fold -s
		read -p '' button_up
		printf "\nButton press sound is $button_down\n" | fold -s
		printf "\nButton depress sound is $button_up\n" | fold -s
	else
		sound="no"
		button_down=''
		button_up=''
	fi
	if [ "$sound" == "yes" ]
		then
			sh_template="keybind-script-template-with-sound.sh"
			channel_template="channel-template-with-sound.sh"
		else
			sh_template="keybind-script-template-no-sound.sh"
			channel_template="channel-template-no-sound.sh"
	fi

	printf "\nDoes your remote have number buttons keyed to numbers 0 through 9?\n" | fold -s
	read -p "Y/N: " number_buttons
	while [[ "$number_buttons" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
		do
			printf "\nBeep Boop! Entry not valid\n" | fold -s
			printf "\nDoes your remote have number buttons keyed to numbers 0 through 9?\n" | fold -s
			read -p "Y/N: " number_buttons
		done
	if [[ "$number_buttons" == @(Y|y|Yes|yes|YES) ]]
		then
			printf "\nHow many channels would you like to set up keybinds for (Maximum: 99)\n" | fold -s
			read -p '' number_of_channels
			if [ "$number_of_channels" -gt 99 ]
				then
					printf "\nNumber too high, setting to 99 channels.\n"
					number_of_channels=99
			fi
			channel_position=1
			leadkey=0
			printf "\nSetting up keybinds for $number_of_channels channels.\n" | fold -s
			eval "echo \"  <keybind key=$leadkey>\"" | sudo tee -a "$homedir""remote/temp.xml"
			while [ $channel_position -le $number_of_channels ]
				do
					key=${channel_position: -1}
					if [ "$key" -eq "0" ]
						then
							leadkey=$(($leadkey+1))
							eval "echo \"  <\keybind>\"" | sudo tee -a "$homedir""remote/temp.xml"
							eval "echo \"  <keybind key=$leadkey>\"" | sudo tee -a "$homedir""remote/temp.xml"
					fi
					channel_number="$leadkey""$key"
					script="$homedir""remote/""$channel_number"".sh"
					eval "echo \"$(cat $channel_template)\"" | sudo tee "$script"
					eval "echo \"$(cat keybind-template.xml)\"" | sudo tee -a "$homedir""remote/temp.xml"
					channel_position=$(($channel_position+1))
					printf "\nChannel $channel_number of $number_of_channels keybind set." | fold -s
				done
			eval "echo \"  <\keybind>\"" | sudo tee -a "$homedir""remote/temp.xml"
			printf "\nChannel bindings complete. Starting key bindings.\n" | fold -s
	fi
	printf "\nDo you wish to bind other buttons on your remote?\n" | fold -s
	read -p "Y/N: " bind_remote
	while [[ "$bind_remote" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
		do
			printf "\nBeep Boop! Entry not valid\n" | fold -s
			printf "\nDo you wish to bind other buttons on your remote?\n" | fold -s
			read -p "Y/N: " bind_remote
		done
	while [[ "$bind_remote" == @("Y"|"y"|"yes"|"Yes"|"YES") ]]
		do
	#		export DISPLAY=:0
			xhost +
			export DISPLAY=:0
			printf "\nEnter the remote button you wish to bind to an action.\n" | fold -s
			key=$(xev -event keyboard | awk -W interactive -F'[ )]+' '/^KeyRelease/ { a[NR+2] } NR in a { printf "%s\n", $8;exit;}')
			printf "\nYou have entered the $key key.\n"
			printf "\nSelect the action you would like this button to perform\n" | fold -s
			"./list.sh"
			command_list=$(cat command_list)
			select script_action in $command_list
				do
					script="$homedir""remote/""$script_action"".sh"
					eval "echo \"$(cat $sh_template)\"" | sudo tee "$script"
					eval "echo \"$(cat keybind-template.xml)\"" | sudo tee -a "$homedir""remote/temp.xml"
					printf "\nThe key $key has been bound to $script_action.\n" | fold -s
					break
				done
			printf "\nBind another key?\n"
			read -p 'Y/N: ' bind_remote
			while [[ "$bind_remote" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
				do
					printf "\nBeep Boop! Entry not valid\n" | fold -s
					printf "\nBind another key?\n"
					read -p 'Y/N: ' bind_remote
				done
		done
	echo "<!-- End of Remote Control Binds set $today -->" | sudo tee -a temp.xml
	fi
}

get_ps () { #check for remote or local install of pseudo channel and install/update if local
printf "\nIs the Pseudo Channel script installed on a remote device?\n" | fold -s
read -p "Y/N: " is_ps_remote_device
while [[ "$is_ps_remote_device" != @(Y|y|Yes|yes|YES|N|n|No|no|NO) ]]
	do
		printf "\nBeep Boop! Entry not valid\n" | fold -s
		printf "\nIs the Pseudo Channel script installed on a remote device?\n" | fold -s
		read -p "Y/N: " is_ps_remote_device
	done
if [[ "$is_ps_remote_device" == @("Y"|"y"|"Yes"|"yes"|"YES") ]]
	then
		printf "\nEnter the IP address of the device running Pseudo Channel:\n" | fold -s
		read -p 'Pseudo Channel Device IP: ' controller_ip
		printf "\nEnter the user login for the device running Pseudo Channel:\n" | fold -s
		read -p 'Pseudo Channel Device Username: ' controller_user
		printf "\nEnter the full location path of the Pseudo Channel directory on the remote device that matches this client (Example: /home/pi/channels_CLIENTNAME):\n" | fold -s
		read -p 'Pseudo Channel Path: ' ps
else
		sudo mkdir -p "$homedir"channels
		ps="$homedir""channels"
		cd "$ps"
		if [ -z "$(ls -A $ps)" ]; then
			first_run_ps=yes
   			printf "\n\nPseudo Channel will now install on this device to the $ps directory.\n" | fold -s
			printf "\nPlease enter which branch of Pseudo Channel to install, master or develop.\n" | fold -s
			printf "\nmaster - stable release branch" | fold -s
			printf "\ndevelop - most up-to-date, but may be unstable\n" | fold -s
			read -p '' branch
			while [ "$branch" ! "master" ] || [ "$branch" ! "develop"]
				do
				printf "\n\nPlease enter either master or develop.\n"
				read -p '' branch
			done
		else
   			first_run_ps=no
			printf "\n\nPseudo Channel will now update.\n" | fold -s
			printf "\nPlease select which branch to update with, master or develop.\n" | fold -s
			printf "\nmaster - stable release branch" | fold -s
			printf "\ndevelop - most up-to-date, but may be unstable\n" | fold -s
			read -p 'master or develop: ' branch
			while [[ "$branch" != @("master"|"develop") ]]
				do
				printf "\nBeep Boop! Entry not valid\n" | fold -s
				printf "\n\nPlease enter either master or develop.\n"
				read -p 'master or develop: ' branch
			done
		fi
		sudo wget https://raw.githubusercontent.com/mutto233/pseudo-channel/"$branch"/main-dir/update-channels-from-git.sh
		if [ $first_run_ps == "yes" ]
			then
			sudo sed -i "s/FIRST_INSTALL=.*/FIRST_INSTALL=true/g" "$ps"/update-channels-from-git.sh
			else
			sudo sed -i "s/FIRST_INSTALL=.*/FIRST_INSTALL=false/g" "$ps"/update-channels-from-git.sh
		fi
		sudo chmod +x update-channels-from-git.sh
		sudo ./update-channels-from-git.sh "$branch"
		sudo mv plex_token-example.py plex_token.py
		sudo sed -i "s/FIRST_INSTALL=.*/FIRST_INSTALL=false/g" "$ps"/update-channels-from-git.sh
		printf "\nPseudo Channel is installed and up-to-date.\n" | fold -s
		cd "$homedir"remote
fi
}

get_plex_server_info () { #get Plex server IP and username
printf "\n+++++PLEX SERVER INFORMATION+++++\n"
printf "\nEnter the IP address of the Plex server:\n" | fold -s
read -p 'Plex Server IP Address: ' server_ip
printf "\nEnter the Plex Server port number:\n" | fold -s
read -p 'Plex Server Port (default 32400): ' server_port
if [ "$server_port" == '' ]
	then
		server_port='32400'
fi
printf "\nEnter the plex authentication token.\nCheck here for help with finding your token: https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/\n"  | fold -s
read -p 'Plex Auth Token: ' server_token
printf "\nEnter the user login for the Plex server device. Not your Plex login:\n" | fold -s
read -p 'Plex Server Device User Login: ' server_user
printf "\nThe Plex Server is $server_user@$server_ip on port $server_port\n" | fold -s
}

get_client_info () { #get RasPlex or other client IP and username
printf "\n+++++PLEX CLIENT INFORMATION+++++\n"
printf "\nEnter the IP address of the Plex client:\n" | fold -s
printf "\nBelow is a list of IP addresses for clients registered with your Plex server.\n" | fold -s 
printf "\nThe IP you are looking for may or may not be listed below.\n" | fold -s
clientlist=$(xmllint --xpath "//Server/@host" "http://$server_ip:$server_port/clients")
sudo echo $clientlist | sed "s| \"|\n\"|g"
read -p 'Client IP: ' client_ip
printf "\nEnter the user login for the Plex client device. (NOT your Plex login):\n" | fold -s 
read -p 'Client User Login: ' client_user
printf "\nThe Plex Client is $client_user@$client_ip\n" | fold -s
}

ssh_keygen () { #get ssh keys
printf "\nNow setting up SSH keys for communication between devices...\n" | fold -s
ssh-keygen -t rsa
printf "\nSetting up connection to client device...\n" | fold -s
ssh-copy-id "$client_user@$client_ip"
printf "\nSetting up connection to server device...\n" | fold -s
ssh-copy-id "$server_user@$server_ip"
if [[ "$is_ps_remote_device" == @(Y|y|yes|Yes|YES) ]]
	then
		printf "\nSetting up connection to controller device...\n" | fold -s
		ssh-copy-id "$controller_user@$controller_ip"
fi

printf "\nEnter the location of the rsa token or press enter for the default location.\n" | fold -s
read -p "RSA Token (default: $homedir.ssh/id_rsa): " rsa
if [[ $rsa == '' ]]
	then
		rsa="$homedir.ssh/id_rsa"
fi
printf "\nRSA key location is $rsa\n" | fold -s
}

get_trailer_variables () { #get variables for trailer downloader script
printf "\nEnter your api key from The Movie Database.\nCheck here for help getting the key: https://developers.themoviedb.org/3/" | fold -s
read -p '' tmdb_api_key

printf "\nEnter the language as an ISO 639-1 value (for US English use en-US)" | fold -s
read -p '' language

printf "\nEnter the region as an ISO 3166-1 value, must be uppercase (United States value is US)" | fold -s
read -p '' region

printf "\nEnter the query string for localized trailers (for United States enter usa)" | fold -s
read -p '' loc

printf "\nEnter the maximum number of movie trailers to download when the trailer download script is run" | fold -s
read -p '' trailers
}

save_variables () { #save variable values to file
if [[ "$do_remote_bindings" == @(Y|y|Yes|yes|YES) ]]
	then
	eval "echo \"$(cat remote_token_template.sh)\"" | sudo tee remote_token.sh
	printf "\nSelect the openbox keybind xml file.\n" | fold -s
	openbox_directory_contents=$(ls "$homedir".config/openbox/)
	select openbox_xml in $openbox_directory_contents
		do
			printf "\nThe file $homedir.config/openbox/$openbox_xml will be appended with set keybind data.\n" | fold -s
			break
		done
		sudo cp "$homedir".config/openbox/"$openbox_xml" "$homedir".config/openbox/backup-"$openbox_xml"
		sudo sed -i $'/<\/keyboard>/{e cat temp.xml\n}' "$homedir".config/openbox/"$openbox_xml"
	fi
if [[ "$is_ps_remote_device" == @(N|n|No|no|NO) ]]
	then
		sudo sed -i "s/token =.*/token = $server_token/g" "$ps"/plex_token.py
		sudo sed -i "s/baseurl =.*/baseurl = $server_ip:$server_port/g" "$ps"/plex_token.py
		sudo sed -i "s/plexClients =.*/plexClients = $ps_client/g" "$ps"/pseudo_config.py
		sudo sed -i "s/    \"TV Shows\" :.*/     \"TV Shows\" : $ps_tv/g" "$ps"/pseudo_config.py
		sudo sed -i "s/    \"Movies\" :.*/     \"Movies\" : $ps_tv/g" "$ps"/pseudo_config.py
		sudo sed -i "s/    \"Commercials\" :.*/     \"Commercials\" : $ps_tv/g" "$ps"/pseudo_config.py
		sudo sed -i "s/useCommercialInjection =.*/useCommercialInjection = $commercials_true" "$ps"/pseudo_config.py
		sudo sed -i "s/dailyUpdateTime =.*/dailyUpdateTime = $reset_time" "$ps"/pseudo_config.py
	fi
}
