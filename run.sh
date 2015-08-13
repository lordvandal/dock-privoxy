#!/bin/sh

/usr/local/bin/privoxy-blist.sh

/usr/sbin/privoxy --no-daemon /etc/privoxy/config
