#!/usr/bin/env bash
#
# Installs the simple-admin to /usr/local/bin.
#

# Global variables
PROG=$0
INTERACTIVE=false
TMPDIR=/tmp/simple-admin-installer

# Set caution flags
set -o nounset
set -o errtrace
set -o errexit
set -o pipefail

# Function for logging and exiting on error
fail() {
    echo "ERROR:" "$@" >&2
    exit 1
}

# Function for cleaning up resources on exit
onexit() {
    rm -rf $TMPDIR
}
trap onexit EXIT

# Function for installing one or more packages if needed
install_packages() {
    local DEPS="$@"
    echo -n "Checking dependencies... "
    if apt-get --simulate install $DEPS | tail -n1 | grep '0 upgraded, 0 newly installed' > /dev/null ; then
        echo "installed"
    else
        echo "not installed"
        echo "The following packages will be installed or updated:"
        echo "    $DEPS"
        if $INTERACTIVE ; then
            echo -n "Press <Ctrl-C> to cancel, or <Enter> to continue: "
            read
        else
            echo "Press <Ctrl-C> to cancel. The installation starts in 5 seconds..."
            sleep 5
        fi
        apt-get --yes install $DEPS
    fi
}

# Function for downloading a URL into a file
download_url() {
    local FILE="$1"
    local URL="$2"
    if ! which curl > /dev/null && ! which wget > /dev/null ; then
        install_packages wget
    fi
    echo -n "Downloading $URL... "
    if which curl > /dev/null ; then
        curl -s -L -o "$FILE" "$URL"
    else
        wget -q -O "$FILE" "$URL"
    fi
    echo "done"
}

# Check for root user
[ `whoami` == 'root' ] || fail "only root can install simple-admin"

# Check for terminal on stdin
if [ -t 0 ] ; then
    INTERACTIVE=true
fi

# Check for install over HTTP (via pipe)
if [ `basename $PROG` != 'install.sh' ] ; then
    if ! which unzip > /dev/null ; then
        install_packages unzip
    fi
    URL="https://github.com/cederberg/simple-admin/archive/master.zip"
    if [ "${VERSION:-}" != "" ] ; then
        URL="https://github.com/cederberg/simple-admin/archive/v${VERSION}.zip"
    fi
    mkdir -p $TMPDIR
    cd $TMPDIR
    download_url simple-admin.zip "$URL"
    unzip -q -u -o simple-admin.zip
    cd simple-admin-*
else
    cd `dirname $PROG`
fi

# Install required packages
install_packages aptitude rsync xz-utils libgeo-ipfree-perl libjson-xs-perl libmath-round-perl

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
[ ! -r bin/simple-trace ] || install bin/simple-trace /usr/local/bin/
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

# Install other files
echo "Installing shared files to /usr/local/share/simple-admin/..."
mkdir -p /usr/local/share/simple-admin
shopt -s nullglob
cp {etc,share}/* /usr/local/share/simple-admin/
shopt -u nullglob

# Check for missing config files
CONFIG_MISSING=""
shopt -s nullglob
for FILE in {etc,share}/*.conf ; do
    CONF=`basename $FILE`
    if [ ! -e "/etc/$CONF" ] ; then
        CONFIG_MISSING="$CONFIG_MISSING $CONF"
    fi
done
shopt -u nullglob
if [ "$CONFIG_MISSING" != '' ] ; then
    echo
    echo "Config files must be manually installed. See web site for examples."
    echo "The following example files can be copied and modified:"
    for FILE in $CONFIG_MISSING ; do
        echo "    /usr/local/share/simple-admin/$FILE"
    done
fi

# Finished
echo
echo "Simple-Admin for Ubuntu is now installed"
