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
echo -n "Checking dependencies... "
DEPS="aptitude rsync lzma libgeo-ipfree-perl libjson-xs-perl libtext-glob-perl"
if apt-get --simulate install $DEPS | tail -n1 | grep '0 upgraded, 0 newly installed' > /dev/null ; then
    echo "installed"
else
    echo "not installed"
    echo "The following packages will be installed or updated:"
    echo "    $DEPS"
    echo -n "Press <Ctrl-C> to cancel, or <Enter> to continue: "
    read
    apt-get --yes install $DEPS
fi

# Install script files
echo "Installing simple-admin scripts to /usr/local/bin/..."
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
echo "Installing man pages to /usr/local/share/man/..."
mkdir -p /usr/local/share/man/man1
cp man/man1/* /usr/local/share/man/man1/
gzip -f /usr/local/share/man/man1/simple-*.1

# Finished
echo "Installation successful."
echo
echo "Simple-Admin for Ubuntu is now installed -- http://www.simple-admin.org/"
echo
echo "NOTE: Config files must be manually installed. See web site for examples."
