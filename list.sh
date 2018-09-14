#!/bin/bash
source remote-functions.sh

command_list=$(compgen -A function)
echo $command_list > command_list
