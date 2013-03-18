#!/usr/bin/env bash
#
# Installs the admin-scripts to /usr/local/bin.
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
[ `whoami` == 'root' ] || fail "only root is allowed to install admin-scripts"

# Install required packages
echo "Installing dependencies..."
apt-get -qq install rsync lzma libgeo-ipfree-perl libjson-xs-perl libtext-glob-perl

# Install script files
echo "Installing admin scripts..."
install --mode=0744 bin/admin-backup-files /usr/local/bin/
install bin/admin-backup-mysql /usr/local/bin/
install bin/admin-backup-status /usr/local/bin/
install bin/admin-backup-sync /usr/local/bin/
install bin/admin-freemem /usr/local/bin/
install --mode=0744 bin/admin-restart /usr/local/bin/
install bin/admin-status /usr/local/bin/
install --mode=0744 bin/admin-uptodate /usr/local/bin/
install bin/admin-utf8 /usr/local/bin/
install --mode=0744 bin/admin-www-logrotate /usr/local/bin/
install bin/admin-www-stats /usr/local/bin/
install bin/admin-www-webalizer /usr/local/bin/
install bin/admin-zcat /usr/local/bin/

# Install man pages
echo "Installing man pages..."
mkdir -p /usr/local/share/man/man1
cp man/man1/* /usr/local/share/man/man1/
gzip -f /usr/local/share/man/man1/admin-*.1

# Finished
echo "...done"
echo "Note: Config files must be installed manually."
