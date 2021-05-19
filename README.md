# docker-lirc

## BIOS

Within advanced BIOS settings we must enable IR !!

## Host setup

1. I have updated /etc/lirc/lirc_options.conf : changed devinput into default so that `mode2` works.

## Testing in alpine container

### ir-keytable

`ir-keytable` cannot be installed in centOS, but is available in alpine image.

Following command can be used:

```
# see https://mauricius.dev/configure-an-infrared-remote-control-with-linux/
# By pressing the buttons on your remote you should see the received codes (scancode) and the protocol supported 
ir-keytable -v -t -p rc-5,rc-5-sz,jvc,sony,nec,sanyo,mce_kbd,rc-6,sharp,xmp
```

### mode2

command to test remote control

```
# replace if needed event5 by proper /dev/input/event : see output ir-keytable
mode2 --driver devinput --device /dev/input/event5
```

Here below example output:

```
#  mode2 --driver devinput --device /dev/input/event5
Using driver devinput on device /dev/input/event5
Trying device: /dev/input/event5
Using device: /dev/input/event5
Warning: Running as root.
code: 0x93b7a46000000000253d060000000000040004005c040000
code: 0x93b7a46000000000253d0600000000000000000000000000
code: 0x93b7a46000000000cee1070000000000040004005c040000
code: 0x93b7a46000000000cee10700000000000000000000000000
```


## Testing CentOS
### detect IR events

on container or in host run command and then try remote.

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
irrecord -d /dev/lirc0 -H default -f ~/RC_XXXX_raw.conf

# convert the raw configuration to normal
# check the contents of the produced file
irrecord -a ~/RC_XXXX_raw.conf  > ~/RC_XXXX.conf

# copy the RC_XXXX.conf to folder ~/RC_XXXX.conf
cp ~/RC_XXXX.conf  /etc/lirc/lircd.conf.d

# give everyone read permission to RC_XXXX.conf
chmod a+r  /etc/lirc/lircd.conf.d/RC_XXXX.conf

# start lirc daemon in container (-e as user root)
lircd -n -d /dev/lirc0 -H default -e 0
# systemctl start lircd

# test the remote by running command in container
irw

```

### check driver and device

In container run following command:

```
ir-keytable
```

## Links

* https://mauricius.dev/configure-an-infrared-remote-control-with-linux/
* https://www.lirc.org/html/configuration-guide.html#why-use-lirc
* http://www.unusedino.de/lirc/html/programs-overview.html
* https://learn.adafruit.com/using-an-ir-remote-with-a-raspberry-pi-media-center/using-other-remotes
