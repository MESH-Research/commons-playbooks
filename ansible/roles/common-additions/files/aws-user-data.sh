#! /bin/sh
### BEGIN INIT INFO
# Provides:          aws-user-data
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# X-Start-Before:    hostname
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Process EC2 instance user data
# Description:       Process EC2 instance user data
### END INIT INFO

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin
DESC="Process EC2 instance user data"
SCRIPTNAME=/etc/init.d/user-data

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

# Load values
fqdn=`curl -s http://169.254.169.254/latest/user-data | awk '$1 ~ /^fqdn:/ { print $2 }'`
hostname=`echo $fqdn | awk -F\. '{ print $1 }'`

#
# Function that starts the daemon/service
#
do_start()
{
  # Set hostname
  echo $fqdn > /etc/hostname
  sed -i "s/^127.0.0.1 .*\$/127.0.0.1 $fqdn $hostname localhost/" /etc/hosts
  hostname $hostname
}

case "$1" in
  start)
        do_start
        ;;
  restart|force-reload)
        do_start
        ;;
  *)
        echo "Usage: $SCRIPTNAME {start|restart}" >&2
        exit 3
        ;;
esac

:
