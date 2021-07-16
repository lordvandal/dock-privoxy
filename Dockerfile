############################################################
# Dockerfile: Alpine Linux :latest & Privoxy
############################################################

FROM alpine:latest

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

ENTRYPOINT ["/bin/sh", "-c"]

CMD ["run.sh"]
