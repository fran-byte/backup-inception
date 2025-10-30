FROM alpine:3.21

# --------------------------------------------------
# Installing MariaDB and Client
# --------------------------------------------------
RUN apk update && apk add --no-cache mariadb mariadb-client

# --------------------------------------------------
# Creating necessary directories
# --------------------------------------------------
RUN mkdir -p /run/mysqld /var/lib/mysql \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql

# --------------------------------------------------
# Copying configuration files and entrypoint script
# --------------------------------------------------
COPY conf/my.cnf /etc/my.cnf
COPY tools/entrypoint.sh /usr/local/bin/

# --------------------------------------------------
# Setting executable permissions
# --------------------------------------------------
RUN chmod +x /usr/local/bin/entrypoint.sh

# --------------------------------------------------
# Exposing MariaDB port and defining volume
# --------------------------------------------------
EXPOSE 3306
VOLUME /var/lib/mysql

# --------------------------------------------------
# Entrypoint and default command
# --------------------------------------------------
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mysqld", "--user=mysql"]


# FROM alpine:3.21

# # --------------------------------------------------
# # Base image: Alpine 3.21 (from Docker Hub)
# # --------------------------------------------------

# # --------------------------------------------------
# # Installing MariaDB and Client
# # --------------------------------------------------
# RUN apk update && apk add --no-cache mariadb mariadb-client

# # --------------------------------------------------
# # Creating necessary directories
# # --------------------------------------------------
# RUN mkdir -p /run/mysqld /var/lib/mysql \
#     && chown -R mysql:mysql /run/mysqld /var/lib/mysql

# # --------------------------------------------------
# # Copying configuration files and scripts
# # --------------------------------------------------
# COPY conf/my.cnf /etc/my.cnf
# COPY tools/entrypoint.sh /usr/local/bin/
# COPY tools/install.sh /usr/local/bin/

# # --------------------------------------------------
# # Setting executable permissions
# # --------------------------------------------------
# RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/install.sh

# # --------------------------------------------------
# # Exposing MariaDB port and defining volume
# # --------------------------------------------------
# EXPOSE 3306
# VOLUME /var/lib/mysql

# # --------------------------------------------------
# # Entrypoint and default command
# # --------------------------------------------------
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD ["mysqld", "--user=mysql"]
