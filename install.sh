#!/usr/bin/env bash
#
# Installs the simple-admin to /usr/local/bin.
#

# Global variables
PROG=$0
INTERACTIVE=false

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

# Function for checking for dependencies
install_deps() {
    DEPS=$*
    echo -n "Checking dependencies... "
    if apt-get --simulate install $DEPS | tail -n1 | grep '0 upgraded, 0 newly installed' > /dev/null ; then
        echo "installed"
    else
        echo "not installed"
        echo "The following packages will be installed or updated:"
        echo "    $DEPS"
        if [ $INTERACTIVE == 'true' ] ; then
            echo -n "Press <Ctrl-C> to cancel, or <Enter> to continue: "
            read
        else
            echo "Press <Ctrl-C> to cancel. The installation starts in 5 seconds..."
            sleep 5
        fi
        apt-get --yes install $DEPS
    fi
}

# Check for root user
[ `whoami` == 'root' ] || fail "only root is allowed to install simple-admin"

# Check for terminal on stdin
if [ -t 0 ] ; then
    INTERACTIVE=true
fi

# Check for install over HTTP (via pipe)
if [ `basename $PROG` != 'install.sh' ] ; then
    cd
    if which curl > /dev/null ; then
        if ! which unzip > /dev/null ; then
            install_deps unzip
        fi
    elif ! which wget unzip > /dev/null ; then
        install_deps wget unzip
    fi
    URL="https://github.com/cederberg/simple-admin/archive/master.zip"
    echo -n "Downloading $URL... "
    if which curl > /dev/null ; then
        curl -s -L -O "$URL"
    else
        wget -q "$URL"
    fi
    unzip -q -u -o master.zip
    rm -f master.zip
    cd simple-admin-master
    echo "done"
else
    cd `dirname $PROG`
fi

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
echo "Installing scripts to /usr/local/bin/..."
install --mode=0744 bin/simple-backup-files /usr/local/bin/
install bin/simple-backup-mysql /usr/local/bin/
install bin/simple-backup-search /usr/local/bin/
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

# Check for missing config files
CONFIG_MISSING=""
for FILE in etc/*.conf ; do
    if [ ! -e /$FILE ] ; then
        CONFIG_MISSING="$CONFIG_MISSING $FILE"
    fi
done
if [ "$CONFIG_MISSING" != '' ] ; then
    echo
    echo "Config files must be manually installed. See web site for examples."
    echo "The following example files can be copied and modified:"
    for FILE in $CONFIG_MISSING ; do
        echo "    $PWD/$FILE"
    done
fi

# Finished
echo
echo "Simple-Admin for Ubuntu is now installed -- http://www.simple-admin.org/"
