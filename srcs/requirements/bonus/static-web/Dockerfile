FROM alpine:3.21
# --------------------------------------------------
# Base Image: Alpine 3.21 (from Docker Hub)
# --------------------------------------------------

# --------------------------------------------------
# Updating APK and installing Nginx
# --------------------------------------------------
RUN apk update && apk add --no-cache nginx

# --------------------------------------------------
# Creating necessary directories for Nginx
# --------------------------------------------------
RUN mkdir -p /run/nginx /var/log/nginx /usr/share/nginx/html

# --------------------------------------------------
# Copying main Nginx configuration
# --------------------------------------------------
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# --------------------------------------------------
# Copying static content to /usr/share/nginx/html
# --------------------------------------------------
COPY ./html /usr/share/nginx/html
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

# --------------------------------------------------
# Exposing HTTP port 8080
# --------------------------------------------------
EXPOSE 8080

# --------------------------------------------------
# Starting Nginx in foreground mode
# --------------------------------------------------
CMD ["nginx", "-g", "daemon off;"]
