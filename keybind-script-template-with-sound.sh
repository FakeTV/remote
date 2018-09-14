#!/bin/bash
cd "$homedir""remote/"
source remote-functions.sh

button_press
"$script_action"
button_depress

exit 0
