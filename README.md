# docker-lirc

## 1. BIOS configuration

Within advanced BIOS settings we must enable IR !!

## 2. Host setup (most likely not needed)

1. I have updated /etc/lirc/lirc_options.conf : changed devinput into default so that `mode2` works.

## 3. Testing in alpine container

### 3.1. ir-keytable

`ir-keytable` cannot be installed in centOS, but works in alpine container.

Following command can be used to see the received codes (scancode) and the protocol supported.
For more information see [configure-an-infrared-remote-control-with-linux](https://mauricius.dev/configure-an-infrared-remote-control-with-linux/)

```
ir-keytable -v -t -p rc-5,rc-5-sz,jvc,sony,nec,sanyo,mce_kbd,rc-6,sharp,xmp
```

### 3.2. mode2 (for driver "`devinput`")

Note that mode2 on alpine doesn't work with option --raw (= access device directly).  Raw mode only works in centos container (see below) !

Command to receive remote control events.

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

Note that this command doesn't recognize all remotes.  E.g. my `belgacom BGC TV V4` remote is not recognized by this, but it does recognize my `JBL` remote and the `Philips-RC5721` remote.

## 4. Testing in CentOS container

### 4.1. mode2 (--raw = access device directly)

On container or in host run following command and then try remote.
This seems to work in all cases.  Also for the fastforward remote control key of my belgacom BGC TV V4 remote which is not recognized by irrecord (even in raw mode).

```
mode2 --driver default --device /dev/lirc0
```

### 4.2. configure new remote control

Run the below on this container or on the host as user root.

```
# stop the LIRC daemon on the host if it is running
systemctl stop lircd

# list all key names
irrecord --list-namespace

# configure new remote control (-f = raw)
irrecord -d /dev/lirc0 -H default -f ~/RC_XXXX_raw.conf

# convert the raw configuration to normal
# check the contents of the produced file
irrecord -a ~/RC_XXXX_raw.conf  > ~/RC_XXXX.conf

# copy the RC_XXXX.conf to folder /etc/lirc/lircd.conf.d/
cp ~/RC_XXXX.conf  /etc/lirc/lircd.conf.d/

# give everyone read permission to RC_XXXX.conf
chmod a+r  /etc/lirc/lircd.conf.d/RC_XXXX.conf

# start lirc daemon in container (-e as user root)
lircd -n -d /dev/lirc0 -H default -e 0

# test the remote by running command in container
irw
```

## 5. Links

* https://www.sbprojects.net/knowledge/ir/index.php
* http://lirc-remotes.sourceforge.net/remotes-table.html
* https://mauricius.dev/configure-an-infrared-remote-control-with-linux/
* https://www.lirc.org/html/configuration-guide.html#why-use-lirc
* http://www.unusedino.de/lirc/html/programs-overview.html
* https://learn.adafruit.com/using-an-ir-remote-with-a-raspberry-pi-media-center/using-other-remotes
