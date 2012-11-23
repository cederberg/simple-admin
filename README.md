admin-scripts
=============
Scripts for simplified Ubuntu server administration and
maintenance.


Requirements
------------
* Ubuntu 12.04
* Bash


Installation
------------
The install script will install required command-line tools and
Perl modules.

1. Run install script (as root):
   - ```./install.sh```
2. Copy & modify config files from ```etc```.


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
/var/log   5
```

All the files in the directories specified will be recursively copied
to a new directory ```/backup/<hostname>/files/<timestamp>```. A
symbolic link ```/backup/<hostname>/files/latest``` always points to
the last completed backup directory. An optional number after each
directory specified the maximum number of days to store these files
(differing from the standard retention policy below).

In order to save space, identical files are hard linked between the
current and the previous backup directories. Only modified files (and
the directory structure) will require more space on the disk.

The first backup every month and day are created with a different
timestamp signature (omitting the hour and minute). The monthly backup
directories are kept indefinitely, but the daily directories are only
preserved for 30 days. Other timestamped backup directories will be
preserved for 24 hours.

The file backup can be run as frequently as every minute, but should
probably be run at least once per day.


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
/backup/host01 root@host02:/backup/
root@host02:/backup/host02 /backup/
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


admin-www-logrotate
-------------------

**TODO:** Update tool and docs.


admin-www-restart
-----------------

**TODO:** Update tool and docs.


admin-www-stats
---------------

**TODO:** Update tool and docs.


admin-www-webalizer
-------------------

**TODO:** Update tool and docs.
