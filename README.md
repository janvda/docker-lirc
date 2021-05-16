# docker-lirc

## Testing

### detect IR events

on host run command and then try remote.

```
mode2 --driver default --device /dev/lirc0
```

### check driver and device

In container run following command:

```
ir-keytable
```

## Links

* http://www.unusedino.de/lirc/html/programs-overview.html
