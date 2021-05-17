# docker-lirc

## BIOS

Within advanced bios settings we must enable IR !!

## Host setup

1. I have updated /etc/lirc/lirc_options.conf : changed devinput into default so that `mode2` works.

## Testing

### detect IR events

on host run command and then try remote.

```
mode2 --driver default --device /dev/lirc0
```

### configure new remote control

Run the below on the host as user root.

```
# stop the LIRC daemon
systemctl stop lircd

# list all key names
irrecord --list-namespace

# configure new remote control (-f = raw)
irrecord -d /dev/lirc0 -h default -f ~/RC_XXXX_raw.conf

# convert the raw configuration to normal
# check the contents of the produced file
irrecord -a ~/RC_XXXX_raw.conf  > ~/RC_XXXX.conf

# copy the RC_XXXX.conf to folder ~/RC_XXXX.conf
cp ~/RC_XXXX.conf  /etc/lirc/lircd.conf.d

# restart LIRC daemon
systemctl start lircd

# test the remote
irw

```

### check driver and device

In container run following command:

```
ir-keytable
```

## Links

* https://www.lirc.org/html/configuration-guide.html#why-use-lirc
* http://www.unusedino.de/lirc/html/programs-overview.html
* https://learn.adafruit.com/using-an-ir-remote-with-a-raspberry-pi-media-center/using-other-remotes
