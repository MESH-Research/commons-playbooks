#! /bin/sh
### BEGIN INIT INFO
# Provides:          aws-route53
# Required-Start:    $network +aws-ec2-user-data
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Dynamic DNS using Route53
# Description:       Dynamic DNS using Route53
### END INIT INFO

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin
DESC="Dynamic DNS using Route53"
SCRIPTNAME=/etc/init.d/aws-route53

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

# Configuration files
zoneid_file="/etc/aws-route53/zone-id"
sample_file="/etc/aws-route53/changeset.json.sample"
upsert_file="/etc/aws-route53/upsert.json"
delete_file="/etc/aws-route53/delete.json"

# Load values
region=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F\" '/region/ {print $4}'`
zoneid=`cat $zoneid_file`
publicip=`dig +short myip.opendns.com @resolver1.opendns.com`
fqdn=`hostname -f`

#
# Function that starts the daemon/service
#
do_start()
{
  sed -e "s/\${IP}/$publicip/g" -e "s/\${FQDN}/$fqdn/g" -e "s/\${ACTION}/UPSERT/g" $sample_file > $upsert_file
  sed -e "s/\${IP}/$publicip/g" -e "s/\${FQDN}/$fqdn/g" -e "s/\${ACTION}/DELETE/g" $sample_file > $delete_file
  aws route53 change-resource-record-sets --region $region --hosted-zone-id $zoneid --change-batch file://${upsert_file} 1> /tmp/aws-route53 2>&1
}

#
# Function that stops the daemon/service
#
do_stop()
{
  if test -f $delete_file; then
    aws route53 change-resource-record-sets --region $region --hosted-zone-id $zoneid --change-batch file://${delete_file} 1> /tmp/aws-route53 2>&1
  fi
}

case "$1" in
  start)
    do_start
    ;;
  stop)
    do_stop
    ;;
  restart|force-reload)
    do_start
    ;;
  *)
    echo "Usage: $SCRIPTNAME {start|stop|restart}" >&2
    exit 3
    ;;
esac

:
