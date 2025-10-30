FROM debian:bullseye-20231030

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    adminer \
    php \
    php-mysql \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8090

CMD ["php", "-S", "0.0.0.0:8090", "-t", "/usr/share/adminer"]