#!/bin/sh
set -e

# Permissions
chown -R nobody:nobody /var/www/html
chmod -R 755 /var/www/html
find /var/www/html -type f -exec chmod 644 {} \;

# Copy WordPress if volume is empty
if [ -z "$(ls -A /var/www/html)" ]; then
    wget -q --no-check-certificate https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp/
    cp -a /tmp/wordpress/. /var/www/html/
    rm -rf /tmp/wordpress /tmp/wordpress.tar.gz
    chown -R nobody:nobody /var/www/html
fi

# Wait for MariaDB
DB_PASSWORD=$(cat /run/secrets/mariadb_user_password)

for i in $(seq 1 15); do
    if mysql -h mariadb -u db_user -p"$DB_PASSWORD" -e "SELECT 1;" &> /dev/null; then
        break
    fi
    sleep 2
    [ $i -eq 15 ] && echo "MariaDB connection failed" && exit 1
done

# WordPress setup
if ! wp core is-installed --allow-root --path=/var/www/html 2>/dev/null; then
    [ ! -f /var/www/html/wp-config.php ] && wp config create \
        --dbhost=mariadb \
        --dbname=wordpress \
        --dbuser=db_user \
        --dbpass="$DB_PASSWORD" \
        --allow-root \
        --path=/var/www/html

    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="frromero WordPress" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="$(cat /run/secrets/wp_manager_password)" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root \
        --path=/var/www/html

    [ -f /usr/local/bin/init-users.php ] && php /usr/local/bin/init-users.php || true
fi

exec php-fpm83 -F