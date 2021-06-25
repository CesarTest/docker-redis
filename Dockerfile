FROM docker.io/ubuntu:bionic

LABEL maintainer="sameer@damagehead.com"

ENV REDIS_VERSION=4.0.9 \
    REDIS_USER=redis \
    REDIS_RUN_DIR=/run/redis \
    REDIS_DATA_DIR=/var/lib/redis \
    REDIS_LOG_DIR=/var/log/redis

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server=5:${REDIS_VERSION}* \
 && sed 's/^bind /# bind /' -i /etc/redis/redis.conf \
 && sed 's/^logfile /# logfile /' -i /etc/redis/redis.conf \
 && sed 's/^daemonize yes/daemonize no/' -i /etc/redis/redis.conf \
 && sed 's/^protected-mode yes/protected-mode no/' -i /etc/redis/redis.conf \
 && sed 's/^# unixsocket /unixsocket /' -i /etc/redis/redis.conf \
 && sed 's/^# unixsocketperm 700/unixsocketperm 777/' -i /etc/redis/redis.conf \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh

RUN usermod -g 0 -u 1001 redis && \
    chgrp -R 0   ${REDIS_DATA_DIR}  ${REDIS_LOG_DIR}  && \
    chmod -R g=u ${REDIS_DATA_DIR}  ${REDIS_LOG_DIR}  && \ 
    chmod 755 /sbin/entrypoint.sh  

EXPOSE 6379/tcp
CMD ["/sbin/entrypoint.sh"]
