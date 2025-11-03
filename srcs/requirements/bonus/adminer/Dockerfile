FROM alpine:3.21

ENV ADMINER_VERSION=5.4.1

RUN apk add --no-cache wget ca-certificates php php-session php-mysqli
RUN wget https://github.com/vrana/adminer/releases/download/v$ADMINER_VERSION/adminer-$ADMINER_VERSION.php -O /srv/index.php

WORKDIR /srv

EXPOSE 8090

CMD ["php", "-S", "0.0.0.0:8090", "-t", "/srv"]