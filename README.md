admin-scripts
=============
Scripts for simplified Ubuntu server administration and
maintenance.


Requirements
------------
* Ubuntu 12.04
* Perl
* Perl - Geo::IPfree
* Perl - JSON::XS


Installation
------------
1. ```apt-get install libgeo-ipfree-perl```
2. ```apt-get install libjson-xs-perl```
3. ```cp bin/admin-* /usr/local/bin/```
4. Copy & modify config files in ```etc```


admin-status
------------
**Syntax:** ```admin-status```

Checks the status of a number of services on the machine.
Configured in ```/etc/admin-status.conf``` with one line
per service (and PID file):

```
cron    /var/run/crond.pid
sshd    /var/run/sshd.pid
```
