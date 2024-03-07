#!/bin/ash

# bash syntax is with [[ and ]], adapted to Bourne shell (sh/busybox) syntax for alpine linux is with [ and ]

config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

preserve_perms() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ -e $OLD ]; then
    cp -a $OLD ${NEW}.incoming
    cat $NEW > ${NEW}.incoming
    mv ${NEW}.incoming $NEW
  fi
  config $NEW
}

PRIVOXYDIR=/etc/privoxy
EASYLISTA=easylist.script.filter
EASYLISTB=easylist.script.action

#FORWARD_DNS=tor
#FORWARD_PORT=5566

PRIVOXY_CONF=$PRIVOXYDIR/config
FORWARD_RULE="forward   /       "
RET=$(grep "^${FORWARD_RULE}" ${PRIVOXY_CONF})

chown -R privoxy.privoxy $PRIVOXYDIR

# If there's no existing log file, move this one over; 
# otherwise, kill the new one
if [ ! -e var/log/privoxy/logfile ]; then
  mv /var/log/privoxy/logfile.new /var/log/privoxy/logfile
else
  rm -f /var/log/privoxy/logfile.new
fi

#preserve_perms etc/rc.d/rc.privoxy.new
config etc/privoxy/config.new
config etc/privoxy/match-all.action.new
config etc/privoxy/regression-tests.action.new
config etc/privoxy/trust.new
config etc/privoxy/user.action.new
config etc/privoxy/user.filter.new

# These files are not intended to be edited and will be overwritten.
# To disregard, uncomment these and the .new renaming in privoxy.SlackBuild.
config etc/privoxy/default.action.new
config etc/privoxy/default.filter.new
#for conf_file in etc/privoxy/templates/*.new; do
#  config $conf_file
#done
if [ "$FORWARD_DNS" != "" ] && [ "$FORWARD_PORT" != "" ]; then
  echo "Forwarding DNS exist. Adding forwarding directive to ${PRIVOXY_CONF}"
  #comment out existing directive
  sed -i "/$(echo "${FORWARD_RULE}" | sed "s#\/#\\\/#g")/d" ${PRIVOXY_CONF}
  echo "Adding forwarding rule"
  echo "${FORWARD_RULE}${FORWARD_DNS}:${FORWARD_PORT}" >> ${PRIVOXY_CONF}
fi

#if [ -e "$PRIVOXYDIR/$EASYLISTA" ] && [ -e "$PRIVOXYDIR/$EASYLISTB" ]; then
#  echo "Easy Lists Found. Skipping download..."
#else
#  echo "Files not found! Running download..."
  /usr/local/bin/privoxy-blist.sh -v 1
#fi

/usr/sbin/privoxy --no-daemon /etc/privoxy/config
