#!/bin/sh
set -e

# Secrets and database configuration
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/mariadb_user_password)
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-db_user}

# Create directories and set permissions
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Initialize database if first run
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Install system tables
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Create initialization script
    cat > /tmp/mariadb_init.sql << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
DELETE FROM mysql.user WHERE User NOT IN ('${MYSQL_USER}', 'root', 'mysql', 'mariadb.sys') OR User = '' OR Host = '';
FLUSH PRIVILEGES;
EOF

    # Start temporary instance for initialization
    mysqld --user=mysql --init-file=/tmp/mariadb_init.sql &
    MYSQL_PID=$!

    # Wait for MySQL to be ready
    for i in $(seq 1 30); do
        if echo 'SELECT 1;' | mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" 2>/dev/null; then
            break
        fi
        sleep 2
    done

    # Cleanup temporary instance
    kill -TERM $MYSQL_PID 2>/dev/null
    wait $MYSQL_PID 2>/dev/null || true
    rm -f /tmp/mariadb_init.sql
fi

# Start MariaDB in foreground
exec mysqld --user=mysql