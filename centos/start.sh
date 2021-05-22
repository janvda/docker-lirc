#!/bin/sh -v
[[ -e "/var/lirc_raw_data/lirc0_events" ]] || mkfifo /var/lirc_raw_data/lirc0_events

mode2 --driver default --device /dev/lirc0 > /var/lirc_raw_data/lirc0_events

#sleep 36000