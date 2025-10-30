FROM alpine:3.21

RUN apk update && apk add --no-cache redis

CMD ["redis-server", "--bind", "0.0.0.0", "--protected-mode", "no"]
