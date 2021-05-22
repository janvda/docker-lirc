#!/bin/sh -v
[[ -e "/var/lirc_raw_data/lirc0_events" ]] || mkfifo /var/lirc_raw_data/lirc0_events
[[ -e "/var/lirc_raw_data/lirc0_errors" ]] || mkfifo /var/lirc_raw_data/lirc0_errors

#mode2 --driver default --device /dev/lirc0 > /var/lirc_raw_data/lirc0_events 2> /var/lirc_raw_data/lirc0_errors

sleep 36000