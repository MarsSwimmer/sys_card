#!/bin/bash

# This command will close all active conky
killall conky
sleep 2s

# Only the config listed below will be avtivated
# if you want to combine with another theme, write the command here
conky -c $HOME/.config/conky/sys_card/card_app_compute.conf &> /dev/null &
conky -c $HOME/.config/conky/sys_card/card_app_mem.conf &> /dev/null &
conky -c $HOME/.config/conky/sys_card/card_sys_monitor.conf &> /dev/null &
conky -c $HOME/.config/conky/sys_card/card_weather.conf &> /dev/null &

exit