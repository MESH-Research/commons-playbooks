#! /bin/sh
### BEGIN INIT INFO
# Provides:          self-signed-certificate
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# X-Start-Before:    apache2 nginx
# X-Start-After:     user-data
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Create self-signed TLS certificate
# Description:       Create self-signed TLS certificate
### END INIT INFO

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin
DESC="Create self-signed TLS certificate"
SCRIPTNAME=/etc/init.d/self-signed-certificate

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

# Configuration files
server_private_key="/etc/nginx/ssl/self-signed.key"
server_cert="/etc/nginx/ssl/self-signed.crt"
openssl_conf_template="/etc/ssl/self-signed-certificate-openssl.cnf.example"
openssl_conf="/etc/ssl/self-signed-certificate-openssl.cnf"
ca_conf="/etc/ca-certificates.conf"
ca_cert="/usr/share/ca-certificates/app/self-signed.crt"

# Load values
fqdn=`hostname -f`

#
# Function that starts the daemon/service
#
do_start()
{

# Check for existing key/certificate.
  if test -f $server_private_key && test -f $server_cert; then
    echo "Self-signed certificates have already been generated."
  else

    # Create OpenSSL template with our desired FQDN.
    sed "s/example.com/$fqdn/g" $openssl_conf_template > $openssl_conf

    # Create self-signed SAN wildcard server certifcate.
    openssl req -new -nodes -x509 -batch -days 3650 -newkey rsa:2048 -keyout $server_private_key -out $server_cert -extensions v3_req -config $openssl_conf

    # Create self-signed SAN wildcard CA (browser) certificate.
    openssl req -new -nodes -x509 -batch -days 3650 -key $server_private_key -out $ca_cert -extensions v3_ca -config $openssl_conf

    # Update CA certificate conf.
    if ! grep -FLxq "$server_cert" $ca_conf; then
      echo "$server_cert" >> $ca_conf
    fi

    # Update CA certificates bundle.
    update-ca-certificates --fresh

  fi

}

#
# Function that stops the daemon/service
#
do_stop()
{
  echo "This service has no daemon and nothing to unset."
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
