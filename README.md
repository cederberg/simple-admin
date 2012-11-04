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


admin-freemem
-------------
Cleans filesystem cache (if possible) to recover memory.

**Syntax:** admin-freemem

Forces a filesystem sync followed by a write
to ```/proc/sys/vm/drop_caches```.


admin-status
------------
Checks the status of a number of services on the machine.

**Syntax:** ```admin-status```

Configured in ```/etc/admin-status.conf``` with one line
per service (and PID file):

```
cron    /var/run/crond.pid
sshd    /var/run/sshd.pid
```


admin-uptodate
--------------
Runs a check to determine if the system requires updates.

**Syntax:** ```admin-update [-s] [-m]```  

Option | Description
-------|-------------------------------------------------
-s     | Check only for security updates.
-m     | Mail administrator instead of printing results.


admin-utf8
----------
Converts a file or directory to UTF-8 (from ISO-8859-1). Only if needed.

**Syntax:** ```admin-utf8 (check|convert) <file or dir>```

Use either ```check``` to detect file encoding, or ```convert``` to
convert all ISO-8859-1 file(s).

