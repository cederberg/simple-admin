simple-admin
============
Scripts for simplified Ubuntu server administration and
maintenance.

Web Site: http://cederberg.github.com/simple-admin


Requirements
------------
* Ubuntu 12.04
* Bash
* ...and some command-line tools (auto-installed)


Installation
------------
The install script will install required command-line tools and
Perl modules.

1. Run install script (as root):
   - `./install.sh`
2. Copy & modify config files from `etc`.


admin-backup-files
------------------
Performs a filesystem backup for configured directories.

**Syntax:** `admin-backup-files [-v]`

Option | Description
-------|-------------------------------------------------
-v     | Print verbose output.

Configured in `/etc/admin-backup-files.conf` with one line
per directory to backup:

```
/etc
/home
/root
/var/log   5
```

All the files in the directories specified will be recursively copied
to a new directory `/backup/<hostname>/files/<timestamp>`. A
symbolic link `/backup/<hostname>/files/latest` always points to
the last completed backup directory. An optional number after each
directory specifies the maximum number of days to store the files
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

**Syntax:** `admin-backup-mysql [-v]`

Option | Description
-------|-------------------------------------------------
-v     | Print verbose output.

Configured in `/etc/admin-backup-mysql.conf` with one line
per database to backup:

```
database1 user password
database2 user password --ignore-table=table1
```

The `/backup/<hostname>/mysql/` directory is used to
store the output MySQL dump files (compressed). Backup files are
kept for 30 days, except the first backup file from each month
(which is kept indefinitely).

The MySQL backup should be run once per day. More frequent runs
will overwrite the previous backup.


admin-backup-sync
-----------------
Performs a remote file sync for configured directories.

**Syntax:** `admin-backup-sync [-v]`

Option | Description
-------|-------------------------------------------------
-v     | Print verbose output.

Configured in `/etc/admin-backup-sync.conf` with one line
for each pair of source and destination directories:

```
/backup/host01 root@host02:/backup/
root@host02:/backup/host02 /backup/
```

The file syncronization use `rsync` and will update and
remove files on the receiving side, so be careful to sync the
correct backup subdirectories.


admin-freemem
-------------
Cleans filesystem cache (if possible) to recover memory.

**Syntax:** `admin-freemem`

Forces a filesystem sync followed by a write
to `/proc/sys/vm/drop_caches`.


admin-restart
-------------
Restarts a group of services in a predefined order.

**Syntax:** `admin-restart [-q] <group>`

Option | Description
-------|-------------------------------------------------
-q     | Quiet mode. Only prints errors to stderr.

Configured in `/etc/admin-restart.conf` using shell script syntax
for defining each group with description, start and stop:

```
group_web="Restart the Nginx and Jetty services"

start_web() {
    start jetty 10
    wget --quiet --spider localhost:8080 || fail "jetty not running"
    start nginx
}

stop_web() {
    stop nginx 10 force
    stop jetty 30 force
}
```

A number of built-in commands are available to simplify monitoring
the startup or shutdown of services:

Command   | Description
----------|-------------------------------------------------
`start` | Starts a service and optionally waits for the process to start.
`stop`  | Stops a service and optionally waits for the process to quit.
`alert` | Prints a message to stderr.
`fail`  | Exits and prints a message to stderr.
`log`   | Prints a log message (if not in quiet mode).


admin-status
------------
Checks the status of a number of services on the machine.

**Syntax:** `admin-status`

Configured in `/etc/admin-status.conf` with one line
per service (and PID file):

```
cron    /var/run/crond.pid
sshd    /var/run/sshd.pid
```


admin-uptodate
--------------
Runs a check to determine if the system requires updates.

**Syntax:** `admin-uptodate [-s] [-m]`  

Option | Description
-------|-------------------------------------------------
-s     | Check only for security updates.
-m     | Mail root instead of printing results.


admin-utf8
----------
Converts files to UTF-8 (from ISO-8859-1) if needed.

**Syntax:** `admin-utf8 (check|convert) <files or dirs>`

Use either `check` to detect file encoding, or `convert` to
convert all ISO-8859-1 files.


admin-www-logrotate
-------------------
Rotates HTTP access log files.

**Syntax:** `admin-www-logrotate [-v]`

Option | Description
-------|-------------------------------------------------
-v     | Print verbose output.

Configured in `/etc/admin-www-logrotate.conf` with a number of
shell variables:

```
# Shell command to release old log files
COMMAND="/usr/sbin/nginx -s reopen"

# Base directory for access log files
LOG_DIR=/var/log/www

# Maximum log file age (days)
LOG_EXPIRES=356

# Statistics directory 
STAT_DIR=/srv/logstats
```

The tools will rename any file matching `*.log` in the `LOG_DIR`
directory hierarchy. Immediately afterwards the server command is
run to create new log files. Finally the old log files are compressed
and `admin-www-stats` is used to process their data.


admin-www-stats
---------------
Processes HTTP access log files and generates summary statistics.
Output can be generated in text and/or JSON format.

**Syntax:** `admin-www-stats [--json <file>] [--text <file>] <logs>`

Option   | Description
---------|-------------------------------------------------
--json   | Write JSON output to the specified file.
--text   | Write text output to the specified file.
\<logs\> | Log files to process or `-` to read stdin.

If no output option is specified, the default is a text report
to stdout. The log files may be compressed (in bzip2, gzip, lzip
or xz format).

The tool attempts to automatically recognize the order of the
fields in the HTTP access logs. The field order is therefore
allowed to vary between files. In addition to recognizing the
standard log fields, a number of additional parameters can be
appended to each line. Here is a recommended Nginx format:

```
log_format custom '$remote_addr - $remote_user [$time_local] "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" $host cache:$upstream_cache_status '
                  'time:$request_time backend:$upstream_response_time';
```

This will print log files with entries similar to this edited one
(with one line per entry):

```
66.249.73.70 - - [07/Dec/2012:00:05:17 +0000] "GET / HTTP/1.1" 200 3391
"-" "Mozilla/5.0 ..." www.site.com cache:MISS time:0.451 backend:0.008
```


admin-www-webalizer
-------------------
Processes HTTP access log files with Webalizer (not automatically
installed). This tool is scheduled for removal in the future.

**Syntax:** `admin-www-webalizer [-v]`

Option | Description
-------|-------------------------------------------------
-v     | Print verbose output.

Configured in `/etc/admin-www-webalizer.conf` with a number of
shell variables:

```
# Base directory for access log files (with webalizer.conf in subdirs)
LOG_DIR=/var/log/www

# Base directory for stats output (same subdirs as in LOG_DIR)
OUTPUT_DIR=/srv/webstats

# Extra Webalizer command-line options
OPTIONS="-c /etc/webalizer/webalizer.conf"
```

A base `webalizer.conf` file is placed in `/etc` (or elsewhere)
and additional (possibly empty) `webalizer.conf` files are placed
in each HTTP access log directory to process (subdir to `LOG_DIR`).


admin-zcat
----------
Utility to output data from any compressed file.

**Syntax:** `admin-www-webalizer <files>`

Works similar to `zcat` (from `zutils` package), but also supports
the `lzma` format properly. File compression is detected from file
extensions `bz2`, `gz`, `lzma` or `xz`. Other file extensions are
handled as uncompressed files (with `cat`).
