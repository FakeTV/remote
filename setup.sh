#!/bin/bash
source setup-functions.sh

set_home_dir
install_dependencies
figlet Your Plex Server
get_plex_server_info
figlet Pseudo Channel
get_ps
if [[ "$is_ps_remote_device" == @(N|n|No|no|NO) ]]
	then
		get_ps_config
fi
figlet Your Plex Server
get_client_info
figlet SSH keys
ssh_keygen
figlet Remote Control
remote_bind_start
figlet final steps
save_variables
sudo chmod 777 "$homedir"remote
sudo service lightdm restart
exit 0
