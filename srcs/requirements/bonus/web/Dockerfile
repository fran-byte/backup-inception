FROM alpine:3.21

RUN apk add --no-cache nginx \
    && mkdir -p /run/nginx

COPY ./html /usr/share/nginx/html

RUN echo 'server { \
    listen 8080; \
    root /usr/share/nginx/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ =404; \
    } \
}' > /etc/nginx/http.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]