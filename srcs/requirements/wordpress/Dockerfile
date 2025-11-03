FROM alpine:3.21

RUN apk add --no-cache \
        php83 \
        php83-fpm \
        php83-mysqli \
        php83-curl \
        php83-dom \
        php83-json \
        php83-mbstring \
        php83-xml \
        php83-zip \
        php83-phar \
        php83-session \
        php83-openssl \
        php83-tokenizer \
        wget \
        curl \
        mariadb-client \
    && mkdir -p /var/www/html /run/php \
    && chown -R nobody:nobody /var/www/html /run/php \
    && chmod -R 755 /var/www/html

RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /tmp/ \
    && cp -a /tmp/wordpress/. /var/www/html/ \
    && rm -rf /tmp/wordpress /tmp/wordpress.tar.gz \
    && chown -R nobody:nobody /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \;

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/install.sh /usr/local/bin/install.sh
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY tools/init-users.php /usr/local/bin/init-users.php
RUN chmod +x /usr/local/bin/install.sh /usr/local/bin/entrypoint.sh \
    && /usr/local/bin/install.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
