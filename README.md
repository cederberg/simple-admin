admin-scripts
=============
Scripts for simplified Ubuntu server administration and
maintenance.


Requirements
------------
* Ubuntu 12.04
* rsync
* lzma
* Perl
* Perl - Geo::IPfree
* Perl - JSON::XS


Installation
------------
1. Install dependencies:
   - ```apt-get install rsync```
   - ```apt-get install lzma```
   - ```apt-get install libgeo-ipfree-perl```
   - ```apt-get install libjson-xs-perl```
2. Copy binaries into place:
   - ```cp bin/admin-* /usr/local/bin/```
3. Copy & modify config files.


admin-backup-files
------------------
Performs a filesystem backup for configured directories.

**Syntax:** admin-backup-files [-v]

Option | Description
-------|-------------------------------------------------
-v     | Print verbose output.

Configured in ```/etc/admin-backup-files.conf``` with one line
per directory to backup:

```
/etc
/home
/root
```

All the files in the directories specified will be recursively
copied to ```/backup/<hostname>/current/```, which serves as a
snapshot backup directory. Previous (replaced) versions of files
are kept in the ```/backup/<hostname>/history/``` directory.

Separate history directories per minute, day and month are
maintained. The minute history is only preserved for 24 hours
and a single new directory is created per backup run. The daily
history is preserved for 30 days and thereafter only the monthly
history is kept.

The files are hard linked between the various history directories
to preserve space. The file backup can be run as frequently as
every minute, but should be run at least once per day.


admin-backup-mysql
------------------
Performs a MySQL dump of configured databases.

**Syntax:** admin-backup-mysql [-v]

Option | Description
-------|-------------------------------------------------
-v     | Print verbose output.

Configured in ```/etc/admin-backup-mysql.conf``` with one line
per database to backup:

```
database1 user password
database2 user password --ignore-table=table1
```

The ```/backup/<hostname>/mysql/``` directory is used to
store the output MySQL dump files (compressed). Backup files are
kept for 30 days, except the first backup file from each month
(which is kept indefinitely).

The MySQL backup should be run once per day. More frequent runs
will overwrite the previous backup.


admin-backup-sync
-----------------
Performs a remote file sync for configured directories.

**Syntax:** admin-backup-sync [-v]

Option | Description
-------|-------------------------------------------------
-v     | Print verbose output.

Configured in ```/etc/admin-backup-sync.conf``` with one line
for each pair of source and destination directories:

```
/backup/host01/ root@host02:/backup/host01/
root@host02:/backup/host02/ /backup/host02/
```

The file syncronization use ```rsync``` and will update and
remove files on the receiving side, so be careful to sync the
correct backup subdirectories.


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

**Syntax:** ```admin-uptodate [-s] [-m]```  

Option | Description
-------|-------------------------------------------------
-s     | Check only for security updates.
-m     | Mail root instead of printing results.


admin-utf8
----------
Converts a file or directory to UTF-8 (from ISO-8859-1). Only if needed.

**Syntax:** ```admin-utf8 (check|convert) <file or dir>```

Use either ```check``` to detect file encoding, or ```convert``` to
convert all ISO-8859-1 file(s).

