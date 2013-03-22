#!/usr/bin/env bash
#
# Installs the simple-admin to /usr/local/bin.
#

# Set caution flags
set -o nounset
set -o errtrace
set -o errexit
set -o pipefail

# Function for logging and exiting on error
fail() {
    echo "ERROR:" $* >&2
    exit 1
}

# Check for root user
[ `whoami` == 'root' ] || fail "only root is allowed to install simple-admin"

# Install required packages
echo "Installing dependencies..."
apt-get -qq install rsync lzma libgeo-ipfree-perl libjson-xs-perl libtext-glob-perl

# Install script files
echo "Installing simple-admin scripts..."
install --mode=0744 bin/simple-backup-files /usr/local/bin/
install bin/simple-backup-mysql /usr/local/bin/
install bin/simple-backup-status /usr/local/bin/
install bin/simple-backup-sync /usr/local/bin/
install bin/simple-fileinfo /usr/local/bin/
install bin/simple-freemem /usr/local/bin/
install --mode=0744 bin/simple-restart /usr/local/bin/
install bin/simple-status /usr/local/bin/
install --mode=0744 bin/simple-uptodate /usr/local/bin/
install bin/simple-utf8 /usr/local/bin/
install --mode=0744 bin/simple-www-logrotate /usr/local/bin/
install bin/simple-www-stats /usr/local/bin/
install bin/simple-zcat /usr/local/bin/

# Install man pages
echo "Installing man pages..."
mkdir -p /usr/local/share/man/man1
cp man/man1/* /usr/local/share/man/man1/
gzip -f /usr/local/share/man/man1/simple-*.1

# Finished
echo "...done"
echo "Note: Config files must be installed manually."
