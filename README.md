simple-admin
============
Scripts for simplified Debian and Ubuntu server administration
and maintenance.

Web Site: http://www.simple-admin.org/


Requirements
------------
* Ubuntu 10.04 LTS (or later) or Debian 6.0 (or later)
* ...a few command-line tools (handled by installer)


Installation
------------
The automated installer script downloads and copies files to locations
under in `/usr/local`. It also installs the required command-line tools
and Perl modules.

* `curl -L get.simple-admin.org | bash` -- for curl supporters
* `wget -qO - get.simple-admin.org | bash` -- for wget fans
* ...or run directly from a download directory: `./install.sh`

To install a specified version, add a `VERSION` variable for `bash`:

* `curl -L get.simple-admin.org | VERSION="1.3" bash`
* `wget -qO - get.simple-admin.org | VERSION="1.3" bash`

Configuration files can be copied & modified from
`/usr/local/share/simple-admin/*.conf` examples (after installation).

