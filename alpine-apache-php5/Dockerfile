FROM alpine:3.8
LABEL maintainer="Ryan Schulze - https://github.com/ryanschulze"
LABEL description="A basic apache/php5 image using alpine 3.8"

# env variables required during build / start
ENV APP_PORT=80\
    WEBAPP_ROOT=\
    WEBSERVER_UID=

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

COPY files/* /var/tmp/

# make sure apk-tools is up-to-date
# php5-iconv requires gnu-libconv
RUN apk --no-cache --update upgrade && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing gnu-libiconv && \
    apk add --no-cache \
    apache2 \
    bash \
    curl \
    php5-apache2 \
    php5-ctype \
    php5-curl \
    php5-dom \
    php5-gd \
    php5-iconv \
    php5-json \
    php5-mcrypt \
    php5-mysql \
    php5-openssl \
    php5-pdo_mysql \
    php5-phar \
    php5-xml \
    php5-zlib \
    shadow \
    && apk add --no-cache add php5-cli \
    && mkdir -p /run/apache2 /opt/utils/ \
    && ln -sf /usr/bin/php5 /usr/local/bin/php \
    && curl -sS https://getcomposer.org/installer | /usr/local/bin/php -- --install-dir=/usr/local/bin --filename=composer \
    && mkdir -p /opt/utils/pre-init.d /opt/utils/pre-exec.d /app \
    && mv /var/tmp/start.sh /opt/utils/start.sh \
    && chmod -R 755 /opt/utils/ /app \
    && chown -R apache:apache /app \
    && rm -rf /var/cache/apk/* \
    && echo '[i] Setup done'

EXPOSE $APP_PORT

HEALTHCHECK CMD curl --fail http://localhost:$APP_PORT || exit 1

ENTRYPOINT ["/opt/utils/start.sh"]

