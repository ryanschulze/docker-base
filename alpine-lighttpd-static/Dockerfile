FROM alpine:3.8
LABEL maintainer="Ryan Schulze - https://github.com/ryanschulze"
LABEL description="A basic lighttpd image using alpine 3.7"

# env variables required during build / start
ENV APP_PORT=80\
    WEBSERVER_UID=

COPY files/* /var/tmp/

# make sure apk-tools is up-to-date
RUN apk --no-cache --update upgrade && \
    apk add --no-cache \
    lighttpd \
    bash \
    shadow \
    && mkdir -p /opt/utils/pre-init.d /opt/utils/pre-exec.d /app \
    && mv /var/tmp/start.sh /opt/utils/start.sh \
    && chmod -R 755 /opt/utils/ /app \
    && chown -R lighttpd:lighttpd /app \
    && rm -rf /var/cache/apk/* \
    && echo '[i] Setup done'

EXPOSE $APP_PORT

HEALTHCHECK CMD curl --fail http://localhost:$APP_PORT || exit 1

ENTRYPOINT ["/opt/utils/start.sh"]
