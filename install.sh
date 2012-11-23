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
[ `whoami` != 'root' ] || fail "only root is allowed to install admin-scripts"

# Install required packages
apt-get -qq install rsync lzma libgeo-ipfree-perl libjson-xs-perl

# Install binary files
install bin/admin-status /usr/local/bin/
