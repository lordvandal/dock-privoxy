######################################
# Dockerfile: Alpine Linux & Privoxy #
######################################

FROM alpine:3.18.5

COPY run.sh /usr/local/bin/run.sh

RUN apk upgrade --no-cache && \
    apk add --no-cache privoxy privoxy-doc wget tzdata && \
    cp /usr/share/zoneinfo/Europe/Bucharest /etc/localtime && \
    echo "Europe/Bucharest" > /etc/timezone && \
    apk del tzdata &&\
    chmod +x /usr/local/bin/run.sh

RUN for i in /etc/privoxy/config /etc/privoxy/config.new ; do \
        /bin/sed -i "s/listen-address  127.0.0.1/listen-address  0.0.0.0/g" $i ; \
    done
COPY privoxy-blist.sh /usr/local/bin/privoxy-blist.sh
COPY privoxy-blist.conf /usr/local/bin/privoxy-blist.conf

EXPOSE 8118

# HEALTHCHECK --interval=120s --timeout=15s --start-period=120s --retries=2 \
#            CMD curl --fail -x http://127.0.0.1:8118 -s 'https://duckduckgogg42xjoc72x3sjasowoarfbgcmvfimaftt6twagswzczad.onion' -k > /dev/null || exit 1
HEALTHCHECK --interval=300s --timeout=15s --start-period=300s --retries=2 \
           CMD ( wget --no-check-certificate -e use_proxy=yes -e https_proxy=127.0.0.1:8118 --quiet --spider 'https://duckduckgo.com' || \
           wget --no-check-certificate -e use_proxy=yes -e https_proxy=127.0.0.1:8118 --quiet --spider 'https://duckduckgo.com' ) || exit 1

CMD ["run.sh"]
