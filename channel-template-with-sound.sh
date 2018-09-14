#!/bin/bash
cd "$homedir""remote/"
source remote-functions.sh

channel_number="$channel_number"

button_press
channel
button_depress

exit 0
