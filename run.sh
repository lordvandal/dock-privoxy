#!/bin/ash

#bash syntax with [[ and ]], Bourne shell (sh/busybox) syntax for alpine linux is with [ and ]

PRIVOXYDIR=/etc/privoxy
EASYLISTA=easylist.script.filter
EASYLISTB=easylist.script.action

#FORWARD_DNS=tor
#FORWARD_PORT=5566

PRIVOXY_CONF=/etc/privoxy/config
FORWARD_RULE="forward   /       "
RET=$(grep "^${FORWARD_RULE}" ${PRIVOXY_CONF})
if [ "$FORWARD_DNS" != "" ] && [ "$FORWARD_PORT" != "" ]; then
  echo "Forwarding DNS exist. Adding forwarding directive to ${PRIVOXY_CONF}"
  #comment out existing directive
  sed -i "/$(echo "${FORWARD_RULE}" | sed "s#\/#\\\/#g")/d" ${PRIVOXY_CONF}
  echo "Adding forwarding rule"
  echo "${FORWARD_RULE}${FORWARD_DNS}:${FORWARD_PORT}" >> ${PRIVOXY_CONF}
fi

if [ -e "$PRIVOXYDIR/$EASYLISTA" ] && [ -e "$PRIVOXYDIR/$EASYLISTB" ]; then
  echo "Easy Lists Found. Skipping download..."
else
  echo "Files not found! Running download..."
  . /usr/local/bin/privoxy-blist.sh -v 2
fi

/usr/sbin/privoxy --no-daemon /etc/privoxy/config
