simple-admin
============
Command-line tools for simplified Debian and Ubuntu server
administration.

Web Site: https://cederberg.github.io/simple-admin/


Requirements
------------
* Ubuntu 10.04 LTS (or later) or Debian 6.0 (or later)
* ...a few command-line tools (handled by installer)


Installation
------------
The automated installer script downloads and copies files to locations
under in `/usr/local`. It also installs the required command-line tools
and Perl modules.

* `curl -L https://raw.githubusercontent.com/cederberg/simple-admin/master/install.sh | bash` -- for curl supporters
* `wget -qO - https://raw.githubusercontent.com/cederberg/simple-admin/master/install.sh | bash` -- for wget fans
* ...or run directly from a download directory: `./install.sh`

To install a specified version, add a `VERSION` environment variable:

* `curl -L https://raw.githubusercontent.com/cederberg/simple-admin/master/install.sh | VERSION="1.3" bash`
* `wget -qO - https://raw.githubusercontent.com/cederberg/simple-admin/master/install.sh | VERSION="1.3" bash`

Configuration files can be copied & modified from
`/usr/local/share/simple-admin/*.conf` examples (after installation).
