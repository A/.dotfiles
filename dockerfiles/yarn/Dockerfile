FROM alpine:latest

RUN apk add git bash nodejs yarn
VOLUME /src

WORKDIR /src
USER 1000

CMD yarn start
