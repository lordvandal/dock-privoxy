############################################################
# Dockerfile: Alpine Linux :latest & Privoxy
############################################################

FROM alpine:latest

RUN apk update
RUN apk upgrade
RUN apk add privoxy wget tzdata
RUN cp /usr/share/zoneinfo/Europe/Bucharest /etc/localtime
RUN echo "Europe/Bucharest" > /etc/timezone
RUN apk del tzdata

COPY run.sh /usr/local/bin/run.sh
RUN /bin/sed -i "s/listen-address  127.0.0.1/listen-address  0.0.0.0/g" /etc/privoxy/config
COPY privoxy-blist.sh /usr/local/bin/privoxy-blist.sh
COPY privoxy-blist.conf /usr/local/bin/privoxy-blist.conf

EXPOSE 8118

CMD ["run.sh"]
