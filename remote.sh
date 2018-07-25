#!/bin/bash
source remote-functions.sh

if [ "$1" == "lead_number" ]
	then
		button_press
		lead_number
	fi

if [ "$1" == "channel" ]
        then
		button_press
                channel
		button_depress
        fi

if [ "$1" == "reboot" ]
	then
		button_press
		reboot
	fi

if [ "$1" == "shutdown" ]
	then
		button_press
		shutdown
	fi


if [ "$1" == "reset_status_screen" ]
	then
		button_press
		reset_status_screen
		button_depress
	fi

if [ "$1" == "channel_up" ]
	then
		button_press
		channel_up
		button_depress
	fi

if [ "$1" == "channel_down" ]
	then
		button_press
		channel_down
		button_depress
	fi

if [ "$1" == "rasplex_back" ]
	then
		button_press
		rasplex_back
	fi

if [ "$1" == "rasplex_fullscreen" ]
	then
		button_press
		rasplex_fullscreen
	fi

if [ "$1" == "rasplex_up" ]
	then
		button_press
		rasplex_up
	fi

if [ "$1" == "rasplex_down" ]
	then
		button_press
		rasplex_down
	fi

if [ "$1" == "rasplex_left" ]
	then
		button_press
		rasplex_left
	fi

if [ "$1" == "rasplex_right" ]
	then
		button_press
		rasplex_right
	fi

if [ "$1" == "rasplex_select" ]
	then
		button_press
		rasplex_select
	fi

if [ "$1" == "rasplex_volup" ]
	then
		button_press
		rasplex_volup
	fi

if [ "$1" == "rasplex_voldown" ]
	then
		button_press
		rasplex_voldown
	fi

if [ "$1" == "rasplex_mute" ]
	then
		button_press
		rasplex_mute
	fi

if [ "$1" == "rasplex_info" ]
	then
		button_press
		rasplex_info
	fi

if [ "$1" == "rasplex_codec" ]
	then
		button_press
		rasplex_codec
	fi

if [ "$1" == "rasplex_screenshot" ]
	then
		button_press
		rasplex_screenshot
	fi

if [ "$1" == "rasplex_close_dialogue" ]
	then
		button_press
		rasplex_close_dialogue
	fi

if [ "$1" == "rasplex_audio_language" ]
	then
		button_press
		rasplex_audio_language
	fi

if [ "$1" == "rasplex_nextsub" ]
	then
		button_press
		rasplex_nextsub
	fi

if [ "$1" == "rasplex_showsubs" ]
	then
		button_press
		rasplex_showsubs
	fi

exit 0
